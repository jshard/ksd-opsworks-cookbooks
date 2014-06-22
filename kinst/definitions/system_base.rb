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

define :system_base, :enable_builds => false,
                     :enable_iptables => false,
                     :enable_shibboleth => false do

  # make sure we have basic build tools for later installs

  if :enable_builds
    include_recipe "build-essential::default"
  end
 
  # install standard firewall rules and restart service

  if :enable_iptables
    
    template "/etc/sysconfig/iptables" do
      cookbook "#{node.kinst.system.net.iptables_cookbook}"
      source "#{node.kinst.system.net.iptables_template}"
      owner "root"
      group "root"
      mode 0600
      variables( {
        :ipaddress => "#{node.kinst.system.net.ipaddress}",
        :hostname => "#{node.kinst.system.net.hostname}",
        :local_http_port => "#{node.kinst.system.net.local_http_port}",
        :remote_http_port => "#{node.kinst.system.net.remote_http_port}",
      } )
    end
    
    service "iptables" do
      action :restart
    end
  
  end
  
end
