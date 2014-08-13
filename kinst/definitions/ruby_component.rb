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

define :ruby_component, :service  => '__missing__',
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
  
  cmp[:dist_bucket] = "#{node.kinst.component.ruby.dist_bucket}"
  cmp[:dist_path] = "#{node.kinst.component.ruby.dist_path}"
  cmp[:dist_file_name] = "#{node.kinst.component.ruby.dist_versions[cmp[:version]][:dist_file_name]}"
  cmp[:dist_unpacks_to] = "#{node.kinst.component.ruby.dist_versions[cmp[:version]][:dist_unpacks_to]}"
 
  # fetch and unpack distribution file from S3 distribution depot

  s3_file "#{cmp[:vbuild]}/#{cmp[:dist_file_name]}" do
    bucket "#{cmp[:dist_bucket]}"
    remote_path "#{cmp[:dist_path]}/#{cmp[:dist_file_name]}"
    owner "#{cmp[:user]}"
    group "#{cmp[:group]}"
    if node.has_key? :aws_credentials
      aws_access_key_id node[:aws_credentials][:access_key_id]
      aws_secret_access_key node[:aws_credentials][:secret_access_key]
    end
  end
                         
  execute "unpacking distribution file" do
    user "#{cmp[:user]}"
    group "#{cmp[:group]}"
    cwd "#{cmp[:vbuild]}"
    command "tar zxf #{cmp[:vbuild]}/#{cmp[:dist_file_name]}"
  end

  # configure, make, and install from source

  execute "configuring" do
    user "#{cmp[:user]}"
    group "#{cmp[:group]}"
    cwd "#{cmp[:vbuild]}/#{cmp[:dist_unpacks_to]}"
    command "./configure --prefix=#{cmp[:vhome]} --enable-shared"
  end

  execute "compiling" do
    user "#{cmp[:user]}"
    group "#{cmp[:group]}"
    cwd "#{cmp[:vbuild]}/#{cmp[:dist_unpacks_to]}"
    command "make"
  end

  execute "installing" do
    user "#{cmp[:user]}"
    group "#{cmp[:group]}"
    cwd "#{cmp[:vbuild]}/#{cmp[:dist_unpacks_to]}"
    command "make install"
  end

  # add component profile
   
  template "#{cmp[:profile]}" do
    cookbook "#{node.kinst.component.ruby.profile_cookbook}"
    source "#{node.kinst.component.ruby.profile_template}"
    owner "#{cmp[:user]}"
    group "#{cmp[:group]}"
    variables cmp
   end
   
  # add component init
                               
  template "#{cmp[:init]}" do
    cookbook "#{node.kinst.component.ruby.init_cookbook}"
    source "#{node.kinst.component.ruby.init_template}"
    owner "#{cmp[:user]}"
    group "#{cmp[:group]}"
    variables cmp
  end

end
