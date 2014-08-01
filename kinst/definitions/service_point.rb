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

define :service_point, :description => '__missing__',
                       :user        => '__missing__',
                       :group       => '__missing__',
                       :controller  => '__missing__' do
  
  # create service hash from parameters

  svc = generate_service_info( params[:name],
                               params[:description],
                               params[:user],
                               params[:group],
                               params[:controller] )

  # create service user and group
                                 
  group "#{svc[:group]}"
  user "#{svc[:user]}" do
    gid "#{svc[:group]}"
    shell "#{node.kinst.service.user.shell}"
    comment "#{svc[:description]} #{node.kinst.service.user.comment}"
    home "#{node.kinst.service.user.home}/#{svc[:user]}"
    manage_home true
  end
  
  # lock service user to prevent remote access
  
  user "#{svc[:user]}" do
    action :lock
  end

  # install user profile
  
  template "#{node.kinst.service.user.home}/#{svc[:user]}/#{node.kinst.service.user.profile}" do
    cookbook "#{node.kinst.service.user.profile_cookbook}"
    source "#{node.kinst.service.user.profile_template}"
    owner "#{svc[:user]}"
    group "#{svc[:group]}"
    variables svc
  end

  # note -- only necessary because we're putting our apps in a slightly-non-Unix-standard-location
  
  directory "#{node.kinst.service.paths.apps}" do
    owner "root"
    group "root"
    mode "755"
  end
                           
  # create basic service directory structure and bind mounts

  [ svc[:volume],
    svc[:build],
    svc[:volume_home],
    svc[:home], 
    svc[:volume_config],
    svc[:config],
    svc[:volume_base],
    svc[:base],
    svc[:volume_apps],
    svc[:apps]
  ].each do |d|
    directory "#{d}" do
      owner "#{svc[:user]}"
      group "#{svc[:group]}"
      recursive true
    end
  end

  mount "#{svc[:home]}" do
    device "#{svc[:volume_home]}"
    fstype "none"
    options "bind,rw"
    action [ :mount, :enable ]
  end
  
  mount "#{svc[:config]}" do
    device "#{svc[:volume_config]}"
    fstype "none"
    options "bind,rw"
    action [ :mount, :enable ]
  end
    
  mount "#{svc[:base]}" do
    device "#{svc[:volume_base]}"
    fstype "none"
    options "bind,rw"
    action [ :mount, :enable ]
  end
  
  mount "#{svc[:apps]}" do
    device "#{svc[:volume_apps]}"
    fstype "none"
    options "bind,rw"
    action [ :mount, :enable ]
  end

  # add service control structure
  
  [ svc[:control], svc[:profile_dir], svc[:init_dir], svc[:proxy_dir] ].each do |d|
    directory "#{d}" do
      owner "#{svc[:user]}"
      group "#{svc[:group]}"
    end
  end
  
  template "#{svc[:profile]}" do
    cookbook "#{node.kinst.service.paths.profile_cookbook}"
    source "#{node.kinst.service.paths.profile_template}"
    owner "#{svc[:user]}"
    group "#{svc[:group]}"
    variables svc
  end
  
  template "#{svc[:init]}" do
    cookbook "#{node.kinst.service.paths.init_cookbook}"
    source "#{node.kinst.service.paths.init_template}"
    owner "#{svc[:user]}"
    group "#{svc[:group]}"
    mode "700"
    variables svc
  end
  
  template "#{svc[:proxy]}" do
    cookbook "#{node.kinst.service.paths.proxy_cookbook}"
    source "#{node.kinst.service.paths.proxy_template}"
    owner "#{svc[:user]}"
    group "#{svc[:group]}"
    mode "700"
    variables svc
  end
                         
  link "#{svc[:control_link]}" do
    to "#{svc[:init]}"
    owner "#{svc[:user]}"
    group "#{svc[:group]}"
  end
    
end
