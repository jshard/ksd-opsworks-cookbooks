#
# Cookbook Name:: kci
# Recipe:: application_deploy
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

node[:deploy].each do |application, deploy|

  # duck if we're already deployed -- TBD
  
  # deploy applications
  
  if application == 'kc'
    
    kc_application      "#{node.kci.application.application.kc.install_as}" do
      service           "#{node.kci.application.application.kc.service}"
      user              "#{node.kci.application.application.kc.user}"
      group             "#{node.kci.application.application.kc.group}"
      upstream_version  "#{node.kci.application.application.kc.upstream_version}"
      local_version     "#{node.kci.application.application.kc.local_version}"
    end
    
  end

end
