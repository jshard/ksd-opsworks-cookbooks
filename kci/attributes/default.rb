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

default.kci.application.application.kc.install_as        = "kc"
default.kci.application.application.kc.service           = "#{node.kci.application.service.name}"
default.kci.application.application.kc.user              = "#{node.kci.application.service.user}"
default.kci.application.application.kc.group             = "#{node.kci.application.service.group}"
default.kci.application.application.kc.s3_bucket         = "katt-packages"
default.kci.application.application.kc.s3_prefix         = "kuali/kuali-coeus"
default.kci.application.application.kc.s3_basename       = "*** OVERRIDE ***"
default.kci.application.application.kc.upstream_version  = "*** OVERRIDE ***"
default.kci.application.application.kc.local_version     = "*** OVERRIDE ***"

default.kci.application.application.kc.config_dir = "#{node.kinst.service.user.home}/#{node.kci.application.service.user}/kuali/main/dev"
default.kci.application.application.kc.config     = "kc-config.xml"

default.kci.application.application.kc.context_name      = "*** OVERRIDE ***"
default.kci.application.application.kc.application_host  = "*** OVERRIDE ***"
default.kci.application.application.kc.database_url      = "*** OVERRIDE ***"
default.kci.application.application.kc.database_username = "*** OVERRIDE ***"
default.kci.application.application.kc.database_password = "*** OVERRIDE ***"
default.kci.application.application.kc.ldap_url          = "*** OVERRIDE ***"
default.kci.application.application.kc.ldap_username     = "*** OVERRIDE ***"
default.kci.application.application.kc.ldap_password     = "*** OVERRIDE ***"

default.kci.application.application.kc.config_cookbook        = "kci"
default.kci.application.application.kc.config_template        = "kc_config_xml.erb"
default.kci.application.component.tomcat.setenv_cookbook      = "kinst"
default.kci.application.component.tomcat.setenv_template      = "tomcat_setenv_sh.erb"
default.kci.application.component.tomcat.server_xml_cookbook  = "kinst"
default.kci.application.component.tomcat.server_xml_template  = "tomcat_server_xml.erb"


default.kci.application.component.tomcat.setenv_mem_opts         = "-Xms768m -Xmx2304m -XX:MaxPermSize=768m -XX:PermSize=128m -XX:+UseTLAB"
default.kci.application.component.tomcat.setenv_gc_opts          = "#{node.kinst.component.tomcat.setenv_gc_opts}"
default.kci.application.component.tomcat.setenv_kot7_opts        = "#{node.kinst.component.tomcat.setenv_kot7_opts}"
default.kci.application.component.tomcat.setenv_melody_opts      = "#{node.kinst.component.tomcat.setenv_melody_opts}"
default.kci.application.component.tomcat.setenv_misc_opts        = "#{node.kinst.component.tomcat.setenv_misc_opts}"
default.kci.application.component.tomcat.setenv_environment_opts = "-Denvironment=default -Dalt.config.location=#{node.kci.application.application.kc.config_dir}/#{node.kci.application.application.kc.config}"

default.kci.application.component.tomcat.http_port               = "#{node.kinst.component.tomcat.http_port}"
default.kci.application.component.tomcat.proxy_name              = "*** OVERRIDE ***"



#--------------- undeploy phase attributes

#--------------- shutdown phase attributes
