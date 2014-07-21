name             'kinst'
maintainer       'EAS KSD Tools Administrator'
maintainer_email 'eas-ksd-toolsadm@list.arizona.edu'
description      'Kuali Installation Base Cookbook'
long_description <<-EOH
    Provides common functionality used by the Kuali Toolkit Installer (KTI)
    and Kuali Service Installer (KSI) cookbooks.  For a full description,
    see the README.md file at the top level of the cookbook repository.
EOH
license          'See LICENSE.txt file at top of distribution.'
version          '1.0.0'

depends 'build-essential'
depends 'aws'
