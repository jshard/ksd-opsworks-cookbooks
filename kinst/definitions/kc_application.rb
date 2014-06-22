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

define :kc_application, :service           => '__missing__',
                        :user              => '__missing__',
                        :group             => '__missing__',
                        :name              => '__missing__',
                        :upstream_version  => '__missing__',
                        :local_version     => '__missing__' do

  # create application hash from parameters

  app = generate_application_info( params[:service],
                                   params[:user],
                                   params[:group],
                                   params[:name],
                                   "#{params[:upstream_version]}-#{params[:local_version]}" )

  # create application point
  
  application_point "#{app[:name]}" do
    info app
  end
                                   
  # fetch application package from S3 distribution depot -- TBD
  
  # unpack into application versioned deploy location -- TBD

  # stop the kuali service, /etc/opt/kuali/kualictl stop -- TBD

  # drop any old symlink in Tomcat webapps pointed at a previous version -- TBD
      
  # symlink to the new version, as webapps/ROOT so that it deploys as the root application -- TBD
  
  # start up the kuali service, /etc/opt/kuali/kualictl start -- TBD

end
