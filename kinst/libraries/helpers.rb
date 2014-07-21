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

module Kinst
  module Helpers

    def generate_service_info( s_name, s_description, s_user, s_group, s_controller )
      
      s = {
        :name        => s_name,
        :description => s_description,
        :user        => s_user,
        :group       => s_group,
        :controller  => s_controller,
      }
        
      s[ :volume        ] = "#{node.kinst.service.paths.volume}/#{s[:name]}"
      s[ :volume_home   ] = "#{s[:volume]}/#{node.kinst.service.paths.volume_home}"
      s[ :volume_config ] = "#{s[:volume]}/#{node.kinst.service.paths.volume_config}"
      s[ :volume_base   ] = "#{s[:volume]}/#{node.kinst.service.paths.volume_base}"
      s[ :volume_apps   ] = "#{s[:volume]}/#{node.kinst.service.paths.volume_apps}"
        
      s[ :build         ] = "#{s[:volume]}/#{node.kinst.service.paths.build}"
      
      s[ :home          ] = "#{node.kinst.service.paths.home}/#{s[:name]}"
      s[ :config        ] = "#{node.kinst.service.paths.config}/#{s[:name]}"
      s[ :base          ] = "#{node.kinst.service.paths.base}/#{s[:name]}"
      s[ :apps          ] = "#{node.kinst.service.paths.apps}/#{s[:name]}"
          
      s[ :control       ] = "#{s[:config]}/#{node.kinst.service.paths.control}"
      s[ :control_link  ] = "#{s[:config]}/#{s[:controller]}"
      s[ :profile       ] = "#{s[:control]}/#{node.kinst.service.paths.profile}"
      s[ :profile_dir   ] = "#{s[:control]}/#{node.kinst.service.paths.profile_dir}"
      s[ :init          ] = "#{s[:control]}/#{node.kinst.service.paths.init}"
      s[ :init_dir      ] = "#{s[:control]}/#{node.kinst.service.paths.init_dir}"
      s[ :proxy         ] = "#{s[:control]}/#{node.kinst.service.paths.proxy}"
      s[ :proxy_dir     ] = "#{s[:control]}/#{node.kinst.service.paths.proxy_dir}"

      return s
    end
      
    def generate_component_info( c_name, c_service, c_user, c_group, c_version, c_priority )
      
      s = generate_service_info( c_service, '__not_used__', c_user, c_group, '__not_used__' )
      
      c = {
        :name     => c_name,
        :service  => c_service,
        :user     => c_user,
        :group    => c_group,
        :version  => c_version,
        :priority => c_priority,
      }
      
      c[ :vname       ] = "#{c[:name]}-#{c[:version]}"
      
      c[ :build       ] = "#{s[:build]}/#{c[:name]}"
      c[ :vbuild      ] = "#{c[:build]}/#{c[:vname]}"
      c[ :home        ] = "#{s[:home]}/#{c[:name]}"
      c[ :vhome       ] = "#{c[:home]}/#{c[:vname]}"
      c[ :config      ] = "#{s[:config]}/#{c[:name]}"
      c[ :vconfig     ] = "#{c[:config]}/#{c[:vname]}"
      c[ :base        ] = "#{s[:base]}/#{c[:name]}"
      c[ :logs        ] = "#{c[:base]}/#{node.kinst.service.paths.component.logs}"
      
      c[ :profile_dir ] = "#{s[:profile_dir]}"
      c[ :profile     ] = "#{s[:profile_dir]}/#{c[:name]}"
      c[ :init_dir    ] = "#{s[:init_dir]}"
      c[ :init        ] = "#{s[:init_dir]}/#{c[:priority]}#{c[:name]}"
      c[ :proxy_dir   ] = "#{s[:proxy_dir]}"
      c[ :proxy       ] = "#{s[:proxy_dir]}/#{c[:name]}"

      return c
    end
    
    def generate_application_info( a_service, a_user, a_group, a_name, a_version )
      
      s = generate_service_info( a_service, '__not_used__', a_user, a_group, '__not_used__' )
      
      a = {
        :service  => a_service,
        :user     => a_user,
        :group    => a_group,
        :name     => a_name,
        :version  => a_version,
      }
      
      a[ :vname   ] = "#{a[:name]}-#{a[:version]}"
      
      a[ :deploy  ] = "#{s[:apps]}/#{a[:service]}/#{a[:name]}"
      a[ :vdeploy ] = "#{a[:deploy]}/#{a[:vname]}"
      
      a[:tomcat_path]         = "#{node.kinst.service.paths.base}/#{a[:service]}/tomcat"
      a[:tomcat_bin_path]     = "#{a[:tomcat_path]}/bin"
      a[:tomcat_conf_path]    = "#{a[:tomcat_path]}/conf"
      a[:tomcat_lib_path]     = "#{a[:tomcat_path]}/lib"
      a[:tomcat_webapps_path] = "#{a[:tomcat_path]}/webapps"
  
      return a
    end

    def component_already_installed?( c_name )
      return true
    end

  end
end

class Chef::Recipe
  include Kinst::Helpers
end
