#
# Cookbook Name:: kinst
# Recipe:: add_users
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

path_formats = {
  :home_dir       => "/home/%{username}",
  :ssh_dir        => "/home/%{username}/.ssh",
  :auth_keys_file => "/home/%{username}/.ssh/authorized_keys",
}

users = node.default.kinst.system.users
groups = ['dev']

users.each do |userdata|

  username = userdata[:username]
  userpaths = path_formats.map { |k, v| {k => v % userdata } }.reduce(:merge)

  user username do
    supports :manage_home => true
    action :remove
  end

  user username do
    supports :manage_home => true
    shell "/bin/bash"
    home userpaths[:home_dir]
    action :create
  end
  
  directory userpaths[:ssh_dir] do
    user username
    group username
    mode 00700
  end
  
  remote_file userpaths[:auth_keys_file] do
    source userdata[:pubkey]
    owner username
    group username
    mode 0600
  end

end

groups.each do |groupname|

  group groupname do
    action :remove
  end
  
  group groupname do
    action :create
    append true
    members users.map { |u| u[:username] }
  end

end
