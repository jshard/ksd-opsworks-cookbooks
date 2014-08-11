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

group "kc_dev" do
  action :remove
end

memberList = Array.new

node.default.kinst.system.users.each do |u|

  user u[:username] do
    supports :manage_home => true
    action :remove
  end

  memberList.push(u[:username])

  home_dir = "/home/#{u[:username]}"

  user u[:username] do
    supports :manage_home => true
    shell "/bin/bash"
    home home_dir
    action :create
  end
  
  ssh_dir = "#{home_dir}/.ssh"
  
  directory ssh_dir do
    user u[:username]
    group u[:username]
    mode 00700
  end
  
  auth_keys = "#{ssh_dir}/authorized_keys"
  
  remote_file auth_keys do
    source u[:pubkey]
    owner u[:username]
    group u[:username]
    mode 0600
  end

end

group "kc_dev" do
  action :create
  append true
  members memberList
end
