#
# Cookbook Name:: kci
# Recipe:: application_setup
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

# set up system

system_base do
  enable_builds   true
  enable_iptables true
end

# create service point

service_point     "#{node.kci.application.service.name}" do
  description     "#{node.kci.application.service.description}"
  user            "#{node.kci.application.service.user}"
  group           "#{node.kci.application.service.group}"
  controller      "#{node.kci.application.service.controller}"
end

# add components

jdk_component     "#{node.kci.application.component.jdk.install_as}" do
  service         "#{node.kci.application.component.jdk.service}"
  user            "#{node.kci.application.component.jdk.user}"
  group           "#{node.kci.application.component.jdk.group}"
  version         "#{node.kci.application.component.jdk.version}"
  priority        "#{node.kci.application.component.jdk.priority}"
end

orainst_component "#{node.kci.application.component.orainst.install_as}" do
  service         "#{node.kci.application.component.orainst.service}"
  user            "#{node.kci.application.component.orainst.user}"
  group           "#{node.kci.application.component.orainst.group}"
  version         "#{node.kci.application.component.orainst.version}"
  priority        "#{node.kci.application.component.orainst.priority}"
end

tomcat_component  "#{node.kci.application.component.tomcat.install_as}" do
  service         "#{node.kci.application.component.tomcat.service}"
  user            "#{node.kci.application.component.tomcat.user}"
  group           "#{node.kci.application.component.tomcat.group}"
  version         "#{node.kci.application.component.tomcat.version}"
  priority        "#{node.kci.application.component.tomcat.priority}"
end

