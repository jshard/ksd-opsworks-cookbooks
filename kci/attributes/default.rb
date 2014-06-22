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

#---------- application layer attributes

#--------------- setup phase attributes

default.kci.application.service.name                 = "kuali"
default.kci.application.service.description          = "Kuali Coeus Service"
default.kci.application.service.user                 = "kualiadm"
default.kci.application.service.group                = "kuali"
default.kci.application.service.controller           = "kualictl"

default.kci.application.component.jdk.install_as     = "jdk"
default.kci.application.component.jdk.service        = "#{node.kci.application.service.name}"
default.kci.application.component.jdk.user           = "#{node.kci.application.service.user}"
default.kci.application.component.jdk.group          = "#{node.kci.application.service.group}"
default.kci.application.component.jdk.version        = "1.7.0-51"
default.kci.application.component.jdk.priority       = "0"

default.kci.application.component.tomcat.install_as  = "tomcat"
default.kci.application.component.tomcat.service     = "#{node.kci.application.service.name}"
default.kci.application.component.tomcat.user        = "#{node.kci.application.service.user}"
default.kci.application.component.tomcat.group       = "#{node.kci.application.service.group}"
default.kci.application.component.tomcat.version     = "7.0.54"
default.kci.application.component.tomcat.priority    = "7"

#--------------- configure phase attributes

#--------------- deploy phase attributes

default.kci.application.application.kc.install_as       = "kc"
default.kci.application.application.kc.service          = "#{node.kci.application.service.name}"
default.kci.application.application.kc.user             = "#{node.kci.application.service.user}"
default.kci.application.application.kc.group            = "#{node.kci.application.service.group}"
default.kci.application.application.kc.upstream_version = "5.2.1"
default.kci.application.application.kc.local_version    = "1"

#--------------- undeploy phase attributes

#--------------- shutdown phase attributes
