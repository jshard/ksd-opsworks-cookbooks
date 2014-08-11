#
# Cookbook Name:: kinst
# Recipe:: default
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

ba_username = "business_team"
ba_home_dir = "/home/#{ba_username}"
ba_pubkey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCrRzPgPK3tBp987E/lqgGJ+VBw5idpcnOAtZ+d3fsMV5iI9mqWwODq0YMN6vL+Uj3vuGREW6ZKvl0zqp3gfFW5Brn6v4Yk+sirWnSXE7llL0i7Fusfb9AICw+TpaC5htTkuFkNnT7uvXAYywfBwYkwIbZkPczHUPf9NhyZ+zkA25WQ6geLJSCtWPhujVboWlPM5Hd94vLsdeX+ZgsXHeNvBbHgp5jHRs144r2BazZ1yK0Nh6I9DWQtHKlE33tk4ExdLAyDNQMvormPWv0vQFCYttco2eARwaEtopBrxnSAVK8jVj4/wi2rgow2UDo9UO2IEvO0t0pUCkKg3NqdKDIF4T6jlbK6HF9zF03ykpdBHoP3lvVYWXIiZLJQxDWf1VBA6BftO9MO/R7L9u97s0qXhx1Q2YgTzbs3odl5OhP1i9KZJHiCCNt2tvyOBSmyeTkHkmCU8VpcUw25WF2splojPL4jNQ1e7knsui980dmXAbrkKWBLVpdMl4GFcqsTTOeP6Of5Moefp+NzWqV2E0p5FFDzlM+JuP5jyASMBHVsBMgiHGxftGQmBJtzxX6E0rX5jQrsW4CGFJT2y5/GYrJwMAlOkCmLoPWY5mQ0L7UfCv4x6MxZyRYzzCn10QC4oVMhG/KE0+713GJo9nPD4F0x0kYKQ/K/aplvz4Fi+Ak9NQ== rhunter@gemstone"
ssh_dir = "#{ba_home_dir}/.ssh"
auth_keys = "#{ssh_dir}/authorized_keys"

user ba_username do
  supports :manage_home => true
  action :remove
end

user ba_username do
  supports :manage_home => true
  home ba_home_dir
  shell "/bin/bash"	
  action :create
  comment "sets account for business analysts"
end

directory ssh_dir do
  user ba_username
  group ba_username
  mode 00700
end

file auth_keys do
  content ba_pubkey
  owner ba_username
  group ba_username
  mode "0600"
  action :create
end
