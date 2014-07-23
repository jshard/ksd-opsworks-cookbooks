#
# Cookbook Name:: kci
# Recipe:: application_deploy
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

node[:deploy].each do |application, deploy|

  # duck if we're already deployed -- TBD

  # deploy applications

  if application == 'kc'

    kc_application      "#{node.kci.application.application.kc.install_as}" do
      service           "#{node.kci.application.application.kc.service}"
      user              "#{node.kci.application.application.kc.user}"
      group             "#{node.kci.application.application.kc.group}"
      s3_basename       "#{deploy[:s3_basename]}"
      upstream_version  "#{deploy[:upstream_version]}"
      local_version     "#{deploy[:local_version]}"
      context_name      "#{deploy[:context_name]}"
      application_host  "#{deploy[:application_host]}"
      database_url      "#{deploy[:database_url]}"
      database_username "#{deploy[:database_username]}"
      database_password "#{deploy[:database_password]}"
      ldap_url          "#{deploy[:ldap_url]}"
      ldap_username     "#{deploy[:ldap_username]}"
      ldap_password     "#{deploy[:ldap_password]}"

    end

  end

end
