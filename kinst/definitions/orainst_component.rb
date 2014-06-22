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

define :orainst_component, :service  => '__missing__',
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
  
  cmp[:dist_bucket] = "#{node.kinst.component.orainst.dist_bucket}"
  cmp[:dist_path] = "#{node.kinst.component.orainst.dist_path}"
  cmp[:basic_dist_file] = "#{node.kinst.component.orainst.dist_versions[cmp[:version]][:basic_dist_file]}"
  cmp[:jdbc_dist_file] = "#{node.kinst.component.orainst.dist_versions[cmp[:version]][:jdbc_dist_file]}"
  cmp[:sqlplus_dist_file] = "#{node.kinst.component.orainst.dist_versions[cmp[:version]][:sqlplus_dist_file]}"
  cmp[:files_unpack_into] = "#{node.kinst.component.orainst.dist_versions[cmp[:version]][:files_unpack_into]}"
 
  # fetch distribution files from S3 distribution depot

  [ cmp[:basic_dist_file], cmp[:jdbc_dist_file], cmp[:sqlplus_dist_file ] ].each do |f|
    s3_file "#{cmp[:vbuild]}/#{f}" do
      bucket "#{cmp[:dist_bucket]}"
      remote_path "#{cmp[:dist_path]}/#{f}"
      owner "#{cmp[:user]}"
      group "#{cmp[:group]}"
    end
  end
                         
  # unpack the distribution files into the component home
  
  [ cmp[:basic_dist_file], cmp[:jdbc_dist_file], cmp[:sqlplus_dist_file ] ].each do |f|
    execute "unpacking distribution files" do
      user "#{cmp[:user]}"
      group "#{cmp[:group]}"
      cwd "#{cmp[:home]}"
      command "unzip #{cmp[:vbuild]}/#{f}"
    end
  end

  # replace original component vhome with unpacked files
  
  execute "removing original vhome" do
    user "#{cmp[:user]}"
    group "#{cmp[:group]}"
    cwd "#{cmp[:home]}"
    command "rmdir #{cmp[:vhome]}"
  end
  
  execute "replace vhome with unpacked files" do
    user "#{cmp[:user]}"
    group "#{cmp[:group]}"
    cwd "#{cmp[:home]}"
    command "mv #{cmp[:files_unpack_into]} #{cmp[:vhome]}"
  end
     
  # register libraries with dynamic linker
  
  template "/etc/ld.so.conf.d/#{cmp[:name]}.conf" do
    cookbook "#{node.kinst.component.orainst.ldso_cookbook}"
    source "#{node.kinst.component.orainst.ldso_template}"
    owner "#{cmp[:user]}"
    group "#{cmp[:group]}"
    variables cmp
  end
  
  execute "configuring dynamic linker" do
    user "root"
    group "root"
    command "/sbin/ldconfig"
  end

# add component profile
   
  template "#{cmp[:profile]}" do
    cookbook "#{node.kinst.component.orainst.profile_cookbook}"
    source "#{node.kinst.component.orainst.profile_template}"
    owner "#{cmp[:user]}"
    group "#{cmp[:group]}"
    variables cmp
  end
   
  # add component init
                               
  template "#{cmp[:init]}" do
    cookbook "#{node.kinst.component.orainst.init_cookbook}"
    source "#{node.kinst.component.orainst.init_template}"
    owner "#{cmp[:user]}"
    group "#{cmp[:group]}"
    variables cmp
  end

end
                           