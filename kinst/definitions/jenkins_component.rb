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

define :jenkins_component, :service  => '__missing__',
                           :user     => '__missing__',
                           :group    => '__missing__',
                           :version  => '__missing__',
                           :priority => '__missing__' do

  # create component hash from parameters

  cmp = generate_component_info( params[:name],
                                 params[:service],
                                 params[:user],
                                 params[:group],
                                 params[:version],
                                 params[:priority] )

  # create component point
  
  component_point "#{cmp[:name]}" do
    info cmp
  end
                                   
  # add networking specifics
  
  cmp[:ipaddress] = "#{node.kinst.component.jenkins.ipaddress}"
  cmp[:hostname] = "#{node.kinst.component.jenkins.hostname}"
  cmp[:port] = "#{node.kinst.component.jenkins.port}"
  
  # add distribution file specifics
  
  cmp[:dist_bucket] = "#{node.kinst.component.jenkins.dist_bucket}"
  cmp[:dist_path] = "#{node.kinst.component.jenkins.dist_path}"
  cmp[:dist_file_name] = "#{node.kinst.component.jenkins.dist_versions[cmp[:version]][:dist_file_name]}"
  cmp[:dist_install_as] = "#{node.kinst.component.jenkins.dist_versions[cmp[:version]][:dist_install_as]}"

  # pull the jenkins war file from the distribution depot
 
  aws_s3_file "#{cmp[:vbuild]}/#{cmp[:dist_file_name]}" do
    bucket "#{cmp[:dist_bucket]}"
    remote_path "#{cmp[:dist_path]}/#{cmp[:dist_file_name]}"
    owner "#{cmp[:user]}"
    group "#{cmp[:group]}"
  end

  # copy/rename the war file into the component vhome
 
  execute "copying war file into vhome" do
    user "#{cmp[:user]}"
    group "#{cmp[:group]}"
    cwd "#{cmp[:vbuild]}"
    command "cp #{cmp[:vbuild]}/#{cmp[:dist_file_name]} #{cmp[:vhome]}/#{cmp[:dist_install_as]}"
  end

  # add component profile
   
  template "#{cmp[:profile]}" do
    cookbook "#{node.kinst.component.jenkins.profile_cookbook}"
    source "#{node.kinst.component.jenkins.profile_template}"
    owner "#{cmp[:user]}"
    group "#{cmp[:group]}"
    variables cmp
   end
   
  # add component init
                               
  template "#{cmp[:init]}" do
    cookbook "#{node.kinst.component.jenkins.init_cookbook}"
    source "#{node.kinst.component.jenkins.init_template}"
    owner "#{cmp[:user]}"
    group "#{cmp[:group]}"
    variables cmp
  end

  # add component proxy fragment
 
  template "#{cmp[:proxy]}" do
    cookbook "#{node.kinst.component.jenkins.proxy_cookbook}"
    source "#{node.kinst.component.jenkins.proxy_template}"
    owner "#{cmp[:user]}"
    group "#{cmp[:group]}"
    variables cmp
  end

end
