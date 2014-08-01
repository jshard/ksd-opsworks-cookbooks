#
# Copyright (c) 2014, Arizona Board of Regents
# All rights reserved.
#
# This file is part of the KSD OpsWorks Cookbook Repository project.
# It is subject to the license terms in the LICENSE file found in the
# top-level directory of this distribution. No part of this project,
# including this file, may be copied, modified, propagated, or
# distributed except according to the terms contained in the LICENSE
# file.
#

define :kc_application, :service           => '__missing__',
                        :user              => '__missing__',
                        :group             => '__missing__',
                        :s3_basename       => '__missing__',
                        :upstream_version  => '__missing__',
                        :local_version     => '__missing__',
                        :context_name      => '__missing__',
                        :application_host  => '__missing__',
                        :database_url      => '__missing__',
                        :database_username => '__missing__',
                        :database_password => '__missing__',
                        :ldap_url          => '__missing__',
                        :ldap_username     => '__missing__',
                        :ldap_password     => '__missing__' do
                        
  # create application hash from parameters

  app = generate_application_info( params[:service],
                                   params[:user],
                                   params[:group],
                                   params[:name],
                                   "#{params[:upstream_version]}-#{params[:local_version]}" )

  # create application point
  
  application_point "#{app[:name]}" do
    info app
  end
  
  app[:s3_bucket]               = "#{node.kci.application.application.kc.s3_bucket}"
  app[:s3_prefix]               = "#{node.kci.application.application.kc.s3_prefix}"
  app[:dist_name]               = "#{params[:s3_basename]}-#{app[:version]}"
  app[:dist_file_name]          = "#{app[:dist_name]}.tar.gz"
  app[:controller]              = "#{node.kinst.service.paths.config}/#{app[:service]}/#{node.kci.application.service.controller}"
  app[:health_check_dir]        = "#{app[:tomcat_webapps_path]}/#{node.kinst.service.paths.component.health_check_dir}"
  app[:health_check]            = "#{node.kinst.service.paths.component.health_check}"

  app[:kc_config_dir]           = "#{node.kci.application.application.kc.config_dir}"
  app[:kc_config]               = "#{node.kci.application.application.kc.config_dir}/#{node.kci.application.application.kc.config}"
  
  app[:context_name]            = "#{params[:context_name]}"
  app[:application_host]        = "#{params[:application_host]}"
  app[:database_url]            = "#{params[:database_url]}"
  app[:database_username]       = "#{params[:database_username]}"
  app[:database_password]       = "#{params[:database_password]}"
  app[:ldap_url]                = "#{params[:ldap_url]}"
  app[:ldap_username]           = "#{params[:ldap_username]}"
  app[:ldap_password]           = "#{params[:ldap_password]}"
  
  app[:setenv_mem_opts]         = "#{node.kci.application.component.tomcat.setenv_mem_opts}"
  app[:setenv_gc_opts]          = "#{node.kci.application.component.tomcat.setenv_gc_opts}"
  app[:setenv_kot7_opts]        = "#{node.kci.application.component.tomcat.setenv_kot7_opts}"
  app[:setenv_melody_opts]      = "#{node.kci.application.component.tomcat.setenv_melody_opts}"
  app[:setenv_misc_opts]        = "#{node.kci.application.component.tomcat.setenv_misc_opts}"
  app[:setenv_environment_opts] = "#{node.kci.application.component.tomcat.setenv_environment_opts}"

  app[:http_port]               = "#{node.kci.application.component.tomcat.http_port}"
  app[:proxy_name]              = "#{params[:application_host]}"

  
  # fetch application package from S3 distribution depot

  s3_file "#{app[:deploy]}/#{app[:dist_file_name]}" do
    bucket "#{app[:s3_bucket]}"
    remote_path "#{app[:s3_prefix]}/#{app[:dist_file_name]}"
    owner "#{app[:user]}"
    group "#{app[:group]}"
    if node.has_key? :aws_credentials
      aws_access_key_id node[:aws_credentials][:access_key_id]
      aws_secret_access_key node[:aws_credentials][:secret_access_key]
    end
  end

  # unpack into application versioned deploy location

  execute "unpacking distribution file" do
    user "#{app[:user]}"
    group "#{app[:group]}"
    cwd "#{app[:deploy]}"
    command "tar --extract --gunzip --strip-components=1 --file=#{app[:deploy]}/#{app[:dist_file_name]}"
  end

  # stop the kuali service, /etc/opt/kuali/kualictl stop

  execute "stopping KC application service" do
    user "#{app[:user]}"
    group "#{app[:group]}"
    cwd "#{app[:deploy]}"
    command "#{app[:controller]} tomcat stop"
  end
  
  # drop any old symlink in Tomcat webapps pointed at a previous version

  directory "#{app[:tomcat_webapps_path]}" do
    action :delete
    recursive true
  end

  directory "#{app[:tomcat_webapps_path]}" do
    owner "#{app[:user]}"
    group "#{app[:group]}"
    action :create
  end

  # symlink to the new version, as webapps/ROOT so that it deploys as the root application

  execute "deploying application to webapps directory" do
    user "#{app[:user]}"
    group "#{app[:group]}"
    cwd "#{app[:tomcat_webapps_path]}"
    command "ln --force --no-dereference --symbolic  #{app[:deploy]}/#{app[:dist_name]} #{app[:tomcat_webapps_path]}/#{app[:context_name]}"
  end

  # patch web.xml until devs fix it...

  execute "patching web.xml" do
    user "#{app[:user]}"
    group "#{app[:group]}"
    cwd "#{app[:tomcat_webapps_path]}"
    command "sed -i.bak -e 's/http:\\/\\/\localhost:8080/https:\\/\\/#{app[:application_host]}/' #{app[:deploy]}/#{app[:dist_name]}/WEB-INF/web.xml"
  end

  # create health check endpoint for load balancer

  directory "#{app[:health_check_dir]}" do
    owner "#{app[:user]}"
    group "#{app[:group]}"
    mode "0755"
    action :create
  end

  file "#{app[:health_check_dir]}/#{app[:health_check]}" do
    owner "#{app[:user]}"
    group "#{app[:group]}"
    mode "0644"
    action :create
  end

  # application configuration

  directory "#{app[:kc_config_dir]}" do
    owner "#{app[:user]}"
    group "#{app[:group]}"
    action :create
    recursive true
  end

  template "#{app[:kc_config]}" do
    cookbook "#{node.kci.application.application.kc.config_cookbook}"
    source "#{node.kci.application.application.kc.config_template}"
    owner "#{app[:user]}"
    group "#{app[:group]}"
    variables app
  end

  # customize tomcat configuration

  template "#{app[:tomcat_bin_path]}/setenv.sh" do
    cookbook "#{node.kci.application.component.tomcat.setenv_cookbook}"
    source "#{node.kci.application.component.tomcat.setenv_template}"
    owner "#{app[:user]}"
    group "#{app[:group]}"
    variables app
  end

  template "#{app[:tomcat_conf_path]}/server.xml" do
    cookbook "#{node.kci.application.component.tomcat.server_xml_cookbook}"
    source "#{node.kci.application.component.tomcat.server_xml_template}"
    owner "#{app[:user]}"
    group "#{app[:group]}"
    variables app
  end

  # start up the kuali service, /etc/opt/kuali/kualictl start

  execute "starting KC application service" do
    user "#{app[:user]}"
    group "#{app[:group]}"
    cwd "#{app[:deploy]}"
    command "#{app[:controller]} tomcat start"
  end
  
end
