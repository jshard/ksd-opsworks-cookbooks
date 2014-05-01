#
# Cookbook Name:: kti
# Recipe:: toolkit_setup
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

service_point     "#{node.kti.toolkit.service.name}" do
  description     "#{node.kti.toolkit.service.description}"
  user            "#{node.kti.toolkit.service.user}"
  group           "#{node.kti.toolkit.service.group}"
  controller      "#{node.kti.toolkit.service.controller}"
end

# add components that don't have web services associated with them

jdk_component     "#{node.kti.toolkit.component.jdk.install_as}" do
  service         "#{node.kti.toolkit.component.jdk.service}"
  user            "#{node.kti.toolkit.component.jdk.user}"
  group           "#{node.kti.toolkit.component.jdk.group}"
  version         "#{node.kti.toolkit.component.jdk.version}"
  priority        "#{node.kti.toolkit.component.jdk.priority}"
end

groovy_component  "#{node.kti.toolkit.component.groovy.install_as}" do
  service         "#{node.kti.toolkit.component.groovy.service}"
  user            "#{node.kti.toolkit.component.groovy.user}"
  group           "#{node.kti.toolkit.component.groovy.group}"
  version         "#{node.kti.toolkit.component.groovy.version}"
  priority        "#{node.kti.toolkit.component.groovy.priority}"
end

python_component  "#{node.kti.toolkit.component.python.install_as}" do
  service         "#{node.kti.toolkit.component.python.service}"
  user            "#{node.kti.toolkit.component.python.user}"
  group           "#{node.kti.toolkit.component.python.group}"
  version         "#{node.kti.toolkit.component.python.version}"
  priority        "#{node.kti.toolkit.component.python.priority}"
end

ruby_component    "#{node.kti.toolkit.component.ruby.install_as}" do
  service         "#{node.kti.toolkit.component.ruby.service}"
  user            "#{node.kti.toolkit.component.ruby.user}"
  group           "#{node.kti.toolkit.component.ruby.group}"
  version         "#{node.kti.toolkit.component.ruby.version}"
  priority        "#{node.kti.toolkit.component.ruby.priority}"
end

# add a web server to be a front-door proxy to other components

nginx_component   "#{node.kti.toolkit.component.nginx.install_as}" do
  service         "#{node.kti.toolkit.component.nginx.service}"
  user            "#{node.kti.toolkit.component.nginx.user}"
  group           "#{node.kti.toolkit.component.nginx.group}"
  version         "#{node.kti.toolkit.component.nginx.version}"
  priority        "#{node.kti.toolkit.component.nginx.priority}"
end

# add components that have web interfaces that will be proxied by the web server

jenkins_component "#{node.kti.toolkit.component.jenkins.install_as}" do
  service         "#{node.kti.toolkit.component.jenkins.service}"
  user            "#{node.kti.toolkit.component.jenkins.user}"
  group           "#{node.kti.toolkit.component.jenkins.group}"
  version         "#{node.kti.toolkit.component.jenkins.version}"
  priority        "#{node.kti.toolkit.component.jenkins.priority}"
end
