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

define :nginx_component, :service  => '__missing__',
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
                                   
  # add nginx component specifics
  
  cmp[:ipaddress] = "#{node.kinst.component.nginx.ipaddress}"
  cmp[:hostname] = "#{node.kinst.component.nginx.hostname}"
  cmp[:port] = "#{node.kinst.component.nginx.port}"

  cmp[:dist_bucket] = "#{node.kinst.component.nginx.dist_bucket}"
  cmp[:dist_path] = "#{node.kinst.component.nginx.dist_path}"
  cmp[:dist_file_name] = "#{node.kinst.component.nginx.dist_versions[cmp[:version]][:dist_file_name]}"
  cmp[:dist_unpacks_to] = "#{node.kinst.component.nginx.dist_versions[cmp[:version]][:dist_unpacks_to]}"
    
  # install packages required for compilation

  [ "openssl-devel", "pcre-devel", "zlib-devel" ].each do |p|
    package p
  end
     
  # fetch and unpack distribution file from S3 distribution depot

  s3_file "#{cmp[:vbuild]}/#{cmp[:dist_file_name]}" do
    bucket "#{cmp[:dist_bucket]}"
    remote_path "#{cmp[:dist_path]}/#{cmp[:dist_file_name]}"
    owner "#{cmp[:user]}"
    group "#{cmp[:group]}"
    if node.has_key? :aws_credentials
      aws_access_key_id node[:aws_credentials][:access_key_id]
      aws_secret_access_key node[:aws_credentials][:secret_access_key]
    end
  end
                         
  execute "unpacking distribution file" do
    user "#{cmp[:user]}"
    group "#{cmp[:group]}"
    cwd "#{cmp[:vbuild]}"
    command "tar zxf #{cmp[:vbuild]}/#{cmp[:dist_file_name]}"
  end

  # configure, make, and install from source

  execute "configuring source" do
    user "#{cmp[:user]}"
    group "#{cmp[:group]}"
    cwd "#{cmp[:vbuild]}/#{cmp[:dist_unpacks_to]}"
    command %W(
      ./configure --prefix=#{cmp[:vhome]}
                  --sbin-path=#{cmp[:vhome]}/bin/nginx
                  --conf-path=#{cmp[:vconfig]}/nginx.conf
                  --pid-path=#{cmp[:logs]}/nginx.pid
                  --error-log-path=#{cmp[:logs]}/error_log
                  --http-log-path=#{cmp[:logs]}/access_log
                  --user=#{cmp[:user]}
                  --group=#{cmp[:group]}
                  --http-client-body-temp-path=#{cmp[:base]}/temp/client
                  --http-proxy-temp-path=#{cmp[:base]}/temp/proxy
                  --http-fastcgi-temp-path=#{cmp[:base]}/temp/fastcgi
                  --http-uwsgi-temp-path=#{cmp[:base]}/temp/uwsgi
                  --http-scgi-temp-path=#{cmp[:base]}/temp/scgi
    )
  end
  
  execute "compiling" do
    user "#{cmp[:user]}"
    group "#{cmp[:group]}"
    cwd "#{cmp[:vbuild]}/#{cmp[:dist_unpacks_to]}"
    command "make"
  end

  execute "installing" do
    user "#{cmp[:user]}"
    group "#{cmp[:group]}"
    cwd "#{cmp[:vbuild]}/#{cmp[:dist_unpacks_to]}"
    command "make install"
  end

  # perform miscellaneous post-install cleanup
 
  execute "stripping binary" do
    user "#{cmp[:user]}"
    group "#{cmp[:group]}"
    cwd "#{cmp[:vhome]}/bin"
    command "strip nginx"
  end
 
  directory "#{cmp[:vhome]}/html" do
    action :delete
    recursive true
  end
 
  [ "fastcgi.conf", "fastcgi.conf.default", "fastcgi_params", "fastcgi_params.default",
    "koi-utf", "koi-win", "mime.types", "mime.types.default", "nginx.conf", "nginx.conf.default",
    "scgi_params", "scgi_params.default", "uwsgi_params", "uwsgi_params.default", "win-utf"].each do |f|
  file "#{cmp[:vconfig]}/#{f}" do
      action :delete
    end
  end
 
  template "#{cmp[:vconfig]}/mime.types" do
    cookbook "#{node.kinst.component.nginx.mime_types_cookbook}"
    source "#{node.kinst.component.nginx.mime_types_template}"
    owner "#{cmp[:user]}"
    group "#{cmp[:group]}"
    variables cmp
  end
 
  template "#{cmp[:vconfig]}/nginx.conf" do
    cookbook "#{node.kinst.component.nginx.nginx_conf_cookbook}"
    source "#{node.kinst.component.nginx.nginx_conf_template}"
    owner "#{cmp[:user]}"
    group "#{cmp[:group]}"
    variables cmp
  end
 
  directory "#{cmp[:base]}/html" do
    owner "#{cmp[:user]}"
    group "#{cmp[:group]}"
  end

  file "#{cmp[:base]}/html/index.html" do
    owner "#{cmp[:user]}"
    group "#{cmp[:group]}"
    action :touch
  end
 
  file "#{cmp[:base]}/html/robots.txt" do
    owner "#{cmp[:user]}"
    group "#{cmp[:group]}"
    content "User-agent: *\nDisallow: /\n"
  end
 
  directory "#{cmp[:base]}/proxy" do
    owner "#{cmp[:user]}"
    group "#{cmp[:group]}"
  end
 
  directory "#{cmp[:base]}/temp" do
    owner "#{cmp[:user]}"
    group "#{cmp[:group]}"
  end

  # add component profile
   
  template "#{cmp[:profile]}" do
    cookbook "#{node.kinst.component.nginx.profile_cookbook}"
    source "#{node.kinst.component.nginx.profile_template}"
    owner "#{cmp[:user]}"
    group "#{cmp[:group]}"
    variables cmp
   end
   
  # add component init
                               
  template "#{cmp[:init]}" do
    cookbook "#{node.kinst.component.nginx.init_cookbook}"
    source "#{node.kinst.component.nginx.init_template}"
    owner "#{cmp[:user]}"
    group "#{cmp[:group]}"
    variables cmp
  end

end
