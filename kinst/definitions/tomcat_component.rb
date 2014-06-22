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

define :tomcat_component, :service  => '__missing__',
                          :user     => '__missing__',
                          :group    => '__missing__',
                          :version  => '__missing__',
                          :priority => '__missing__' do

  # create component hash from parameters

  cmp = generate_component_info( params[:name],
                                 params[:service],
                                 params[:user],
                                 params[:group],
                                 params[:version],
                                 params[:priority] )

  # create component point
  
  component_point "#{cmp[:name]}" do
    info cmp
  end
                                   
  # add distribution file specifics
  
  cmp[:dist_bucket] = "#{node.kinst.component.tomcat.dist_bucket}"
  cmp[:dist_path] = "#{node.kinst.component.tomcat.dist_path}"
  cmp[:dist_file_name] = "#{node.kinst.component.tomcat.dist_versions[cmp[:version]][:dist_file_name]}"
  cmp[:dist_unpacks_to] = "#{node.kinst.component.tomcat.dist_versions[cmp[:version]][:dist_unpacks_to]}"
  cmp[:javamail_file_name] = "#{node.kinst.component.tomcat.dist_versions[cmp[:version]][:javamail_file_name]}"
  cmp[:javamail_install_as] = "#{node.kinst.component.tomcat.dist_versions[cmp[:version]][:javamail_install_as]}"
  cmp[:ddb_sess_mgr_file_name] = "#{node.kinst.component.tomcat.dist_versions[cmp[:version]][:ddb_sess_mgr_file_name]}"
  cmp[:ddb_sess_mgr_install_as] = "#{node.kinst.component.tomcat.dist_versions[cmp[:version]][:ddb_sess_mgr_install_as]}"
  cmp[:tomcat_native_file_name] = "#{node.kinst.component.tomcat.dist_versions[cmp[:version]][:tomcat_native_file_name]}"
  cmp[:tomcat_native_unpacks_to] = "#{node.kinst.component.tomcat.dist_versions[cmp[:version]][:tomcat_native_unpacks_to]}"
  cmp[:tomcat_native_java_home] = "#{node.kinst.component.tomcat.dist_versions[cmp[:version]][:tomcat_native_java_home]}"
                                
  # add other specifics
    
  cmp[:http_port] = "#{node.kinst.component.tomcat.http_port}"
  cmp[:proxy_name] = "#{node.kinst.component.tomcat.proxy_name}"
  cmp[:manager_user] = "#{node.kinst.component.tomcat.manager_user}"
  cmp[:manager_password] = "#{node.kinst.component.tomcat.manager_password}"
                            
  cmp[:setenv_mem_opts] = "#{node.kinst.component.tomcat.setenv_mem_opts}"
  cmp[:setenv_gc_opts] = "#{node.kinst.component.tomcat.setenv_gc_opts}"
  cmp[:setenv_kot7_opts] = "#{node.kinst.component.tomcat.setenv_kot7_opts}"
  cmp[:setenv_melody_opts] = "#{node.kinst.component.tomcat.setenv_melody_opts}"
  cmp[:setenv_misc_opts] = "#{node.kinst.component.tomcat.setenv_misc_opts}"
  cmp[:setenv_environment_opts] = "#{node.kinst.component.tomcat.setenv_environment_opts}"
 
  # fetch distribution file from S3 distribution depot

  s3_file "#{cmp[:vbuild]}/#{cmp[:dist_file_name]}" do
    bucket "#{cmp[:dist_bucket]}"
    remote_path "#{cmp[:dist_path]}/#{cmp[:dist_file_name]}"
    owner "#{cmp[:user]}"
    group "#{cmp[:group]}"
  end

  # remove the component home and replace it by unpacking/moving the distribution file
 
  execute "removing component vhome" do
    user "#{cmp[:user]}"
    group "#{cmp[:group]}"
    cwd "#{cmp[:vbuild]}"
    command "rmdir #{cmp[:vhome]}"
  end
  
  execute "unpacking distribution file" do
    user "#{cmp[:user]}"
    group "#{cmp[:group]}"
    cwd "#{cmp[:home]}"
    command "tar zxf #{cmp[:vbuild]}/#{cmp[:dist_file_name]}"
  end
   
  execute "moving component to compliant directory name" do
    user "#{cmp[:user]}"
    group "#{cmp[:group]}"
    cwd "#{cmp[:home]}"
    command "mv #{cmp[:dist_unpacks_to]} #{cmp[:vhome]}"
  end
  
  # add javamail and dynamodb session manager libraries to home installation
  
  s3_file "#{cmp[:vhome]}/lib/#{cmp[:javamail_install_as]}" do
      bucket "#{cmp[:dist_bucket]}"
      remote_path "#{cmp[:dist_path]}/#{cmp[:javamail_file_name]}"
      owner "#{cmp[:user]}"
      group "#{cmp[:group]}"
    end

  s3_file "#{cmp[:vhome]}/lib/#{cmp[:ddb_sess_mgr_install_as]}" do
      bucket "#{cmp[:dist_bucket]}"
      remote_path "#{cmp[:dist_path]}/#{cmp[:ddb_sess_mgr_file_name]}"
      owner "#{cmp[:user]}"
      group "#{cmp[:group]}"
    end
      
  # compile and install tomcat apache native library
    
  [ "apr-devel", "openssl-devel" ].each do |p|
    package p
  end
  
  s3_file "#{cmp[:vbuild]}/#{cmp[:tomcat_native_file_name]}" do
    bucket "#{cmp[:dist_bucket]}"
    remote_path "#{cmp[:dist_path]}/#{cmp[:tomcat_native_file_name]}"
    owner "#{cmp[:user]}"
    group "#{cmp[:group]}"
  end
  
  execute "unpacking tomcat native library source" do
    user "#{cmp[:user]}"
    group "#{cmp[:group]}"
    cwd "#{cmp[:vbuild]}"
    command "tar zxf #{cmp[:vbuild]}/#{cmp[:tomcat_native_file_name]}"
  end

  execute "configuring source" do
    user "#{cmp[:user]}"
    group "#{cmp[:group]}"
    cwd "#{cmp[:vbuild]}/#{cmp[:tomcat_native_unpacks_to]}/jni/native"
    command %W(
      ./configure --prefix=#{cmp[:vhome]}
                  --with-apr=/usr/bin/apr-1-config
                  --with-java-home=#{cmp[:tomcat_native_java_home]}
    )
  end

  execute "compiling" do
    user "#{cmp[:user]}"
    group "#{cmp[:group]}"
    cwd "#{cmp[:vbuild]}/#{cmp[:tomcat_native_unpacks_to]}/jni/native"
    command "make"
  end

  execute "installing" do
    user "#{cmp[:user]}"
    group "#{cmp[:group]}"
    cwd "#{cmp[:vbuild]}/#{cmp[:tomcat_native_unpacks_to]}/jni/native"
    command "make install"
  end
    
  # create tomcat base directory structure
  
  %w[ bin conf lib temp webapps work ].each do |d|
    execute "creating #{d} in #{cmp[:base]}" do
      user "#{cmp[:user]}"
      group "#{cmp[:group]}"
      cwd "#{cmp[:base]}"
      command "mkdir #{d}"
    end
  end
  
  execute "copying tomcat-juli.jar from home to base" do
    user "#{cmp[:user]}"
    group "#{cmp[:group]}"
    cwd "#{cmp[:home]}"
    command "cp -p #{cmp[:vhome]}/bin/tomcat-juli.jar #{cmp[:base]}/bin/tomcat-juli.jar"
  end
  
  template "#{cmp[:base]}/bin/setenv.sh" do
    cookbook "#{node.kinst.component.tomcat.setenv_cookbook}"
    source "#{node.kinst.component.tomcat.setenv_template}"
    owner "#{cmp[:user]}"
    group "#{cmp[:group]}"
    variables cmp
  end
  
  # put configuration files in place
    
  template "#{cmp[:base]}/conf/catalina.policy" do
    cookbook "#{node.kinst.component.tomcat.catalina_policy_cookbook}"
    source "#{node.kinst.component.tomcat.catalina_policy_template}"
    owner "#{cmp[:user]}"
    group "#{cmp[:group]}"
    variables cmp
  end
  
  template "#{cmp[:base]}/conf/catalina.properties" do
    cookbook "#{node.kinst.component.tomcat.catalina_properties_cookbook}"
    source "#{node.kinst.component.tomcat.catalina_properties_template}"
    owner "#{cmp[:user]}"
    group "#{cmp[:group]}"
    variables cmp
  end

  template "#{cmp[:base]}/conf/context.xml" do
      cookbook "#{node.kinst.component.tomcat.context_xml_cookbook}"
      source "#{node.kinst.component.tomcat.context_xml_template}"
      owner "#{cmp[:user]}"
      group "#{cmp[:group]}"
      variables cmp
  end
  
  template "#{cmp[:base]}/conf/logging.properties" do
      cookbook "#{node.kinst.component.tomcat.logging_properties_cookbook}"
      source "#{node.kinst.component.tomcat.logging_properties_template}"
      owner "#{cmp[:user]}"
      group "#{cmp[:group]}"
      variables cmp
  end

  template "#{cmp[:base]}/conf/server.xml" do
      cookbook "#{node.kinst.component.tomcat.server_xml_cookbook}"
      source "#{node.kinst.component.tomcat.server_xml_template}"
      owner "#{cmp[:user]}"
      group "#{cmp[:group]}"
      variables cmp
  end

  template "#{cmp[:base]}/conf/tomcat-users.xml" do
      cookbook "#{node.kinst.component.tomcat.tomcat_users_xml_cookbook}"
      source "#{node.kinst.component.tomcat.tomcat_users_xml_template}"
      owner "#{cmp[:user]}"
      group "#{cmp[:group]}"
      variables cmp
  end

  template "#{cmp[:base]}/conf/web.xml" do
      cookbook "#{node.kinst.component.tomcat.web_xml_cookbook}"
      source "#{node.kinst.component.tomcat.web_xml_template}"
      owner "#{cmp[:user]}"
      group "#{cmp[:group]}"
      variables cmp
  end

  # add component profile
   
  template "#{cmp[:profile]}" do
    cookbook "#{node.kinst.component.tomcat.profile_cookbook}"
    source "#{node.kinst.component.tomcat.profile_template}"
    owner "#{cmp[:user]}"
    group "#{cmp[:group]}"
    variables cmp
   end
   
  # add component init
                               
  template "#{cmp[:init]}" do
    cookbook "#{node.kinst.component.tomcat.init_cookbook}"
    source "#{node.kinst.component.tomcat.init_template}"
    owner "#{cmp[:user]}"
    group "#{cmp[:group]}"
    variables cmp
  end
                            
end
