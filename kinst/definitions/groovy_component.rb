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

define :groovy_component, :service  => '__missing__',
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
                                   
  # add distribution file specifics
  
  cmp[:dist_bucket] = "#{node.kinst.component.groovy.dist_bucket}"
  cmp[:dist_path] = "#{node.kinst.component.groovy.dist_path}"
  cmp[:dist_file_name] = "#{node.kinst.component.groovy.dist_versions[cmp[:version]][:dist_file_name]}"
  cmp[:dist_unpacks_to] = "#{node.kinst.component.groovy.dist_versions[cmp[:version]][:dist_unpacks_to]}"
 
  # fetch distribution file from S3 distribution depot

  aws_s3_file "#{cmp[:vbuild]}/#{cmp[:dist_file_name]}" do
    bucket "#{cmp[:dist_bucket]}"
    remote_path "#{cmp[:dist_path]}/#{cmp[:dist_file_name]}"
    owner "#{cmp[:user]}"
    group "#{cmp[:group]}"
  end

  # remove the component home and replace it by unpacking the distribution file

  directory cmp[:vhome] do
    action :delete
    recursive true
  end
  
  execute "unpacking distribution file" do
    user "#{cmp[:user]}"
    group "#{cmp[:group]}"
    cwd "#{cmp[:home]}"
    command "unzip #{cmp[:vbuild]}/#{cmp[:dist_file_name]}"
  end
   
  execute "moving component to compliant directory name" do
    user "#{cmp[:user]}"
    group "#{cmp[:group]}"
    cwd "#{cmp[:home]}"
    command "mv #{cmp[:dist_unpacks_to]} #{cmp[:vhome]}"
  end

  # add component profile
   
  template "#{cmp[:profile]}" do
    cookbook "#{node.kinst.component.groovy.profile_cookbook}"
    source "#{node.kinst.component.groovy.profile_template}"
    owner "#{cmp[:user]}"
    group "#{cmp[:group]}"
    variables cmp
   end
   
  # add component init
                               
  template "#{cmp[:init]}" do
    cookbook "#{node.kinst.component.groovy.init_cookbook}"
    source "#{node.kinst.component.groovy.init_template}"
    owner "#{cmp[:user]}"
    group "#{cmp[:group]}"
    variables cmp
  end

end
