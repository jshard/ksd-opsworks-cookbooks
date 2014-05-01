# KSD OpsWorks Cookbook Repository

This repository contains the Chef cookbooks and recipes used by the
Kuali Service Delivery team at the University of Arizona to build and
configure Kuali-based service stacks using the Amazon Web Services
OpsWorks deployment management service.

For more information on how this repository is used, please contact
the UA KSD team at:

    "EAS KSD Tools Administrators" <eas-ksd-toolsadm@list.arizona.edu>

To work with the contents of this repository, you should first
download and install the Chef Development Kit from:

    http://www.getchef.com/downloads/chef-dk/

Recent versions of ChefDK include a number of useful utilities
(e.g. Berkshelf, Test Kitchen, Foodcritic); if you have an older
ChefDK installed, you may have to do some additional gem installs to
get things working.

# Cookbook Details

## Kuali Installation Base - "kinst"

The "kinst" cookbook was initially created using Berksfile:

    % berks cookbook kinst
    
and then pruned and cleaned up manually thereafter.

## Kuali Toolkit Installer - "kti"

The "kti" cookbook was copied from the "kinst" cookbook, and then
manually whittled down to maintain just the minimum structure, and
also to replace "kinst" with "kti" in a few places.

## Kuali Coeus Installer - "kci"

[ tbd ]

## Kuali Financials Installer - "kfi"

[ tbd ]
