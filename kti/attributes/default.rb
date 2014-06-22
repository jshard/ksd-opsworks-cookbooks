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

#---------- toolkit layer attributes

#--------------- setup phase attributes

default.kti.toolkit.service.name                 = "toolkit"
default.kti.toolkit.service.description          = "Kuali Toolkit Service"
default.kti.toolkit.service.user                 = "toolsadm"
default.kti.toolkit.service.group                = "ktools"
default.kti.toolkit.service.controller           = "toolsctl"

default.kti.toolkit.component.jdk.install_as     = "jdk"
default.kti.toolkit.component.jdk.service        = "#{node.kti.toolkit.service.name}"
default.kti.toolkit.component.jdk.user           = "#{node.kti.toolkit.service.user}"
default.kti.toolkit.component.jdk.group          = "#{node.kti.toolkit.service.group}"
default.kti.toolkit.component.jdk.version        = "1.7.0-51"
default.kti.toolkit.component.jdk.priority       = "0"

default.kti.toolkit.component.groovy.install_as  = "groovy"
default.kti.toolkit.component.groovy.service     = "#{node.kti.toolkit.service.name}"
default.kti.toolkit.component.groovy.user        = "#{node.kti.toolkit.service.user}"
default.kti.toolkit.component.groovy.group       = "#{node.kti.toolkit.service.group}"
default.kti.toolkit.component.groovy.version     = "2.3.0"
default.kti.toolkit.component.groovy.priority    = "0"

default.kti.toolkit.component.python.install_as  = "python"
default.kti.toolkit.component.python.service     = "#{node.kti.toolkit.service.name}"
default.kti.toolkit.component.python.user        = "#{node.kti.toolkit.service.user}"
default.kti.toolkit.component.python.group       = "#{node.kti.toolkit.service.group}"
default.kti.toolkit.component.python.version     = "3.4.0"
default.kti.toolkit.component.python.priority    = "0"

default.kti.toolkit.component.ruby.install_as    = "ruby"
default.kti.toolkit.component.ruby.service       = "#{node.kti.toolkit.service.name}"
default.kti.toolkit.component.ruby.user          = "#{node.kti.toolkit.service.user}"
default.kti.toolkit.component.ruby.group         = "#{node.kti.toolkit.service.group}"
default.kti.toolkit.component.ruby.version       = "2.1.1"
default.kti.toolkit.component.ruby.priority      = "0"

default.kti.toolkit.component.nginx.install_as   = "nginx"
default.kti.toolkit.component.nginx.service      = "#{node.kti.toolkit.service.name}"
default.kti.toolkit.component.nginx.user         = "#{node.kti.toolkit.service.user}"
default.kti.toolkit.component.nginx.group        = "#{node.kti.toolkit.service.group}"
default.kti.toolkit.component.nginx.version      = "1.6.0"
default.kti.toolkit.component.nginx.priority     = "9"

default.kti.toolkit.component.jenkins.install_as = "jenkins"
default.kti.toolkit.component.jenkins.service    = "#{node.kti.toolkit.service.name}"
default.kti.toolkit.component.jenkins.user       = "#{node.kti.toolkit.service.user}"
default.kti.toolkit.component.jenkins.group      = "#{node.kti.toolkit.service.group}"
default.kti.toolkit.component.jenkins.version    = "1.562"
default.kti.toolkit.component.jenkins.priority   = "7"

#--------------- configure phase attributes

#--------------- deploy phase attributes

#--------------- undeploy phase attributes

#--------------- shutdown phase attributes
