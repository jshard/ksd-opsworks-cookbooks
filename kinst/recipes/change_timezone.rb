#
# Cookbook Name:: kinst
# Recipe:: change_timezone
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

execute "Patching /etc/sysconfig/clock" do
  cwd '/etc/sysconfig'
  command %q[ sed -i.bak -e 's/ZONE="UTC"/ZONE="MST"/' clock ]
end

link '/etc/localtime' do
  to '/usr/share/zoneinfo/US/Arizona'
end

%w[ atd ntpd ntpdate rsyslog sendmail ].each do |svc|
  service svc do
    action :restart
    only_if { system "/sbin/chkconfig --list #{svc} | grep 3:on" }
  end
end

