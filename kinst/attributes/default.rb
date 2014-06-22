#---------- kinst attributes

#--------------- system attributes

default.kinst.system.net.ipaddress            = "#{node.ipaddress}"
default.kinst.system.net.hostname             = "#{node.hostname}"
default.kinst.system.net.local_http_port      = "8080"
default.kinst.system.net.remote_http_port     = "80"
default.kinst.system.net.iptables_cookbook    = "kinst"
default.kinst.system.net.iptables_template    = "system_net_iptables.erb"

#--------------- service attributes

default.kinst.service.user.shell              = "/bin/bash"
default.kinst.service.user.comment            = "Administrative User"
default.kinst.service.user.home               = "/home"
default.kinst.service.user.profile            = ".bash_profile"
default.kinst.service.user.profile_cookbook   = "kinst"
default.kinst.service.user.profile_template   = "service_user_profile.erb"

default.kinst.service.paths.volume            = "/vol"
default.kinst.service.paths.volume_home       = "home"
default.kinst.service.paths.volume_config     = "config"
default.kinst.service.paths.volume_base       = "base"
default.kinst.service.paths.volume_apps       = "apps"
default.kinst.service.paths.build             = "__build__"
default.kinst.service.paths.home              = "/opt"
default.kinst.service.paths.config            = "/etc/opt"
default.kinst.service.paths.base              = "/var/opt"
default.kinst.service.paths.apps              = "/var/opt-apps"
default.kinst.service.paths.control           = "__control__"
default.kinst.service.paths.profile           = "profile.sh"
default.kinst.service.paths.profile_cookbook  = "kinst"
default.kinst.service.paths.profile_template  = "service_master_profile.erb"
default.kinst.service.paths.profile_dir       = "profile.d"
default.kinst.service.paths.init              = "init.sh"
default.kinst.service.paths.init_cookbook     = "kinst"
default.kinst.service.paths.init_template     = "service_master_init.erb"
default.kinst.service.paths.init_dir          = "init.d"
default.kinst.service.paths.proxy             = "proxy.conf"
default.kinst.service.paths.proxy_cookbook    = "kinst"
default.kinst.service.paths.proxy_template    = "service_master_proxy.erb"
default.kinst.service.paths.proxy_dir         = "proxy.d"

default.kinst.service.paths.component.logs    = "logs"

#--------------- jdk component attributes

default.kinst.component.jdk.dist_bucket      = "ua-eas-ksd"
default.kinst.component.jdk.dist_path        = "kinst/jdk"
default.kinst.component.jdk.dist_versions = {
  "1.7.0-51" => { 
    :dist_file_name  => "jdk-7u51-linux-x64.tar.gz",
    :dist_unpacks_to => "jdk1.7.0_51",
  }
}
default.kinst.component.jdk.profile_cookbook = "kinst"
default.kinst.component.jdk.profile_template = "jdk_component_profile.erb"
default.kinst.component.jdk.init_cookbook    = "kinst"
default.kinst.component.jdk.init_template    = "jdk_component_init.erb"

#--------------- groovy component attributes

default.kinst.component.groovy.dist_bucket      = "ua-eas-ksd"
default.kinst.component.groovy.dist_path        = "kinst/groovy"
default.kinst.component.groovy.dist_versions = {
  "2.3.0" => { 
    :dist_file_name   => "groovy-binary-2.3.0.zip",
    :dist_unpacks_to  => "groovy-2.3.0",
  }
}
default.kinst.component.groovy.profile_cookbook = "kinst"
default.kinst.component.groovy.profile_template = "groovy_component_profile.erb"
default.kinst.component.groovy.init_cookbook    = "kinst"
default.kinst.component.groovy.init_template    = "groovy_component_init.erb"

#--------------- python component attributes

default.kinst.component.python.dist_bucket      = "ua-eas-ksd"
default.kinst.component.python.dist_path        = "kinst/python"
default.kinst.component.python.dist_versions = {
  "3.4.0" => { 
    :dist_file_name   => "Python-3.4.0.tgz",
    :dist_unpacks_to  => "Python-3.4.0",
  }
}
default.kinst.component.python.profile_cookbook = "kinst"
default.kinst.component.python.profile_template = "python_component_profile.erb"
default.kinst.component.python.init_cookbook    = "kinst"
default.kinst.component.python.init_template    = "python_component_init.erb"

#--------------- ruby component attributes

default.kinst.component.ruby.dist_bucket      = "ua-eas-ksd"
default.kinst.component.ruby.dist_path        = "kinst/ruby"
default.kinst.component.ruby.dist_versions = {
  "2.1.1" => { 
    :dist_file_name   => "ruby-2.1.1.tar.gz",
    :dist_unpacks_to  => "ruby-2.1.1",
  }
}
default.kinst.component.ruby.profile_cookbook = "kinst"
default.kinst.component.ruby.profile_template = "ruby_component_profile.erb"
default.kinst.component.ruby.init_cookbook    = "kinst"
default.kinst.component.ruby.init_template    = "ruby_component_init.erb"

#--------------- orainst component attributes

default.kinst.component.orainst.dist_bucket      = "ua-eas-ksd"
default.kinst.component.orainst.dist_path        = "kinst/orainst"
default.kinst.component.orainst.dist_versions = {
  "12.1.0.1.0" => {
    :basic_dist_file   => "instantclient-basic-linux.x64-12.1.0.1.0.zip",
    :jdbc_dist_file    => "instantclient-jdbc-linux.x64-12.1.0.1.0.zip",
    :sqlplus_dist_file => "instantclient-sqlplus-linux.x64-12.1.0.1.0.zip",
    :files_unpack_into => "instantclient_12_1",
  }
}
default.kinst.component.orainst.ldso_cookbook = "kinst"
default.kinst.component.orainst.ldso_template = "orainst_component_ldso.erb"
default.kinst.component.orainst.profile_cookbook = "kinst"
default.kinst.component.orainst.profile_template = "orainst_component_profile.erb"
default.kinst.component.orainst.init_cookbook    = "kinst"
default.kinst.component.orainst.init_template    = "orainst_component_init.erb"

#--------------- nginx component attributes

default.kinst.component.nginx.ipaddress        = "#{node.kinst.system.net.ipaddress}"
default.kinst.component.nginx.hostname         = "#{node.kinst.system.net.hostname}"
default.kinst.component.nginx.port             = "#{node.kinst.system.net.local_http_port}"
default.kinst.component.nginx.dist_bucket      = "ua-eas-ksd"
default.kinst.component.nginx.dist_path        = "kinst/nginx"
default.kinst.component.nginx.dist_versions = {
  "1.6.0" => { 
    :dist_file_name   => "nginx-1.6.0.tar.gz",
    :dist_unpacks_to  => "nginx-1.6.0"
  }
}
default.kinst.component.nginx.mime_types_cookbook = "kinst"
default.kinst.component.nginx.mime_types_template = "nginx_mime_types.erb"
default.kinst.component.nginx.nginx_conf_cookbook = "kinst"
default.kinst.component.nginx.nginx_conf_template = "nginx_nginx_conf.erb"
default.kinst.component.nginx.profile_cookbook    = "kinst"
default.kinst.component.nginx.profile_template    = "nginx_component_profile.erb"
default.kinst.component.nginx.init_cookbook       = "kinst"
default.kinst.component.nginx.init_template       = "nginx_component_init.erb"

#--------------- jenkins component attributes

default.kinst.component.jenkins.ipaddress        = "127.0.0.1"
default.kinst.component.jenkins.hostname         = "localhost"
default.kinst.component.jenkins.port             = "8081"
default.kinst.component.jenkins.dist_bucket      = "ua-eas-ksd"
default.kinst.component.jenkins.dist_path        = "kinst/jenkins"
default.kinst.component.jenkins.dist_versions = {
  "1.562" => { 
    :dist_file_name   => "jenkins-1.562.war",
    :dist_install_as  => "jenkins.war"
  }
}
default.kinst.component.jenkins.profile_cookbook = "kinst"
default.kinst.component.jenkins.profile_template = "jenkins_component_profile.erb"
default.kinst.component.jenkins.init_cookbook    = "kinst"
default.kinst.component.jenkins.init_template    = "jenkins_component_init.erb"
default.kinst.component.jenkins.proxy_cookbook   = "kinst"
default.kinst.component.jenkins.proxy_template   = "jenkins_component_proxy.erb"

#--------------- tomcat component attributes

default.kinst.component.tomcat.dist_bucket      = "ua-eas-ksd"
default.kinst.component.tomcat.dist_path        = "kinst/tomcat"
default.kinst.component.tomcat.dist_versions = {
  "7.0.54" => { 
    :dist_file_name           => "apache-tomcat-7.0.54.tar.gz",
    :dist_unpacks_to          => "apache-tomcat-7.0.54",
    :javamail_file_name       => "javamail-1.5.2.jar",
    :javamail_install_as      => "javamail.jar",
    :ddb_sess_mgr_file_name   => "AmazonDynamoDBSessionManagerForTomcat-1.0.1.jar",
    :ddb_sess_mgr_install_as  => "dynamodb-session-manager.jar",
    :tomcat_native_file_name  => "tomcat-native-1.1.30-src.tar.gz",
    :tomcat_native_unpacks_to => "tomcat-native-1.1.30-src",
    :tomcat_native_java_home  => "/opt/kuali/jdk/jdk-1.7.0-51"
  }
}
default.kinst.component.tomcat.http_port               = "#{node.kinst.system.net.local_http_port}"
default.kinst.component.tomcat.proxy_name              = "*** OVERRIDE ***"
default.kinst.component.tomcat.manager_user            = "manager"
default.kinst.component.tomcat.manager_password        = "*** OVERRIDE ***"

default.kinst.component.tomcat.setenv_mem_opts         = "-Xms768m -Xmx2g -XX:MaxPermSize=384m -XX:PermSize=128m -XX:+UseTLAB"
default.kinst.component.tomcat.setenv_gc_opts          = "-XX:+UseParallelGC -XX:+UseParallelOldGC -XX:+DisableExplicitGC -verbose:gc -XX:+PrintGCDetails"
default.kinst.component.tomcat.setenv_kot7_opts        = "-Dorg.apache.el.parser.SKIP_IDENTIFIER_CHECK=true -Dorg.apache.jasper.compiler.Parser.STRICT_QUOTE_ESCAPING=false"
default.kinst.component.tomcat.setenv_melody_opts      = "-Djavamelody.system-actions-enabled=false"
default.kinst.component.tomcat.setenv_misc_opts        = "-Djava.awt.headless=true -Djava.util.prefs.syncInterval=2000000 -Dnetworkaddress.cache.ttl=60 -Djava.security.egd=file:///dev/urandom"
default.kinst.component.tomcat.setenv_environment_opts = "-Denvironment=default"

default.kinst.component.tomcat.profile_cookbook             = "kinst"
default.kinst.component.tomcat.profile_template             = "tomcat_component_profile.erb"
default.kinst.component.tomcat.init_cookbook                = "kinst"
default.kinst.component.tomcat.init_template                = "tomcat_component_init.erb"
default.kinst.component.tomcat.setenv_cookbook              = "kinst"
default.kinst.component.tomcat.setenv_template              = "tomcat_setenv_sh.erb"
default.kinst.component.tomcat.catalina_policy_cookbook     = "kinst"
default.kinst.component.tomcat.catalina_policy_template     = "tomcat_catalina_policy.erb"
default.kinst.component.tomcat.catalina_properties_cookbook = "kinst"
default.kinst.component.tomcat.catalina_properties_template = "tomcat_catalina_properties.erb"
default.kinst.component.tomcat.context_xml_cookbook         = "kinst"
default.kinst.component.tomcat.context_xml_template         = "tomcat_context_xml.erb"
default.kinst.component.tomcat.logging_properties_cookbook  = "kinst"
default.kinst.component.tomcat.logging_properties_template  = "tomcat_logging_properties.erb"
default.kinst.component.tomcat.server_xml_cookbook          = "kinst"
default.kinst.component.tomcat.server_xml_template          = "tomcat_server_xml.erb"
default.kinst.component.tomcat.tomcat_users_xml_cookbook    = "kinst"
default.kinst.component.tomcat.tomcat_users_xml_template    = "tomcat_tomcat_users_xml.erb"
default.kinst.component.tomcat.web_xml_cookbook             = "kinst"
default.kinst.component.tomcat.web_xml_template             = "tomcat_web_xml.erb"
