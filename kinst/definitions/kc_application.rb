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
                        :name              => '__missing__',
                        :upstream_version  => '__missing__',
                        :local_version     => '__missing__' do

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

  app[:s3_bucket]               = "#{node.kci.application.kc.s3_bucket}"
  app[:s3_prefix]               = "#{node.kci.application.kc.s3_prefix}"
  app[:dist_name]               = "#{node.kci.application.kc.s3_basename}-#{app[:version]}"
  app[:dist_file_name]          = "#{app[:dist_name]}.tar.gz"
  app[:controller]              = "#{node.kinst.service.paths.config}/#{app[:service]}/#{node.kci.application.service.controller}"
  
  app[:kc_config]               = "#{node.kci.application.application.kc.config}"
  
  app[:context_name]            = "#{default.kci.application.application.kc.context_name}"
  app[:application_host]        = "#{default.kci.application.application.kc.application_host}"
  app[:database_url]            = "#{default.kci.application.application.kc.database_url}"
  app[:database_username]       = "#{default.kci.application.application.kc.database_username}"
  app[:database_password]       = "#{default.kci.application.application.kc.database_password}"
  
  
  app[:setenv_mem_opts]         = "#{node.kci.application.component.tomcat.setenv_mem_opts}"
  app[:setenv_gc_opts]          = "#{node.kci.application.component.tomcat.setenv_gc_opts}"
  app[:setenv_kot7_opts]        = "#{node.kci.application.component.tomcat.setenv_kot7_opts}"
  app[:setenv_melody_opts]      = "#{node.kci.application.component.tomcat.setenv_melody_opts}"
  app[:setenv_misc_opts]        = "#{node.kci.application.component.tomcat.setenv_misc_opts}"
  app[:setenv_environment_opts] = "#{node.kci.application.component.tomcat.setenv_environment_opts}"
  
  # fetch application package from S3 distribution depot

  s3_file "#{app[:deploy]}/#{app[:dist_file_name]}" do
    bucket "#{app[:s3_bucket]}"
    remote_path "#{app[:s3_prefix]}/#{app[:dist_file_name]}"
    owner "#{app[:user]}"
    group "#{app[:group]}"
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
    command "#{app[:controller]} stop"
  end
  
  # drop any old symlink in Tomcat webapps pointed at a previous version

  execute "cleaning out webapps directory" do
    directory "#{app[:tomcat_webapps_path]}" do
      action :delete
      recursive true
    end
    directory "#{app[:tomcat_webapps_path]}" do
      owner "#{app[:user]}"
      group "#{app[:group]}"
      action :create
    end
  end  
      
  # symlink to the new version, as webapps/ROOT so that it deploys as the root application

  execute "deploying application to webapps directory" do
    user "#{app[:user]}"
    group "#{app[:group]}"
    cwd "#{app[:tomcat_webapps_path]}"
    command "ln --force --no-dereference --symbolic  #{app[:deploy]}/#{app[:dist_name]} #{app[:tomcat_webapps_path]}/#{app[:context_name]}"
  end

  # application configuration

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

  # start up the kuali service, /etc/opt/kuali/kualictl start

  # execute "starting KC application service" do
  #   user "#{app[:user]}"
  #   group "#{app[:group]}"
  #   cwd "#{app[:deploy]}"
  #   command "#{app[:controller]} start"
  # end
  
end
