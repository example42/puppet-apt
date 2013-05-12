# Puppet module: apt

Puppet module to manage apt

Originally written by Boian Mihailov - boian.mihailov@gmail.com
Added features by Marco Bonetti
Adapted to Example42 NextGen layout by Alessandro Franceschi

Licence: Apache2

## DESCRIPTION

This module installs and manages apt and automatic updates with unattended-upgrades package.

All the variables used in this module are defined in the apt::params class
(File: $MODULEPATH/apt/manifests/params.pp). Here you can:

- Set default settings and filtering module's specific Users variables
- Add selectors for internal variables to adapt the module to different OSes
- Review and eventually change default settings for variables that affect the
  Example42 extended classes.

Customizations for different projects and logic on how to populate configuration
files should be placed in the $my_project classes.


## USAGE

- Standard Classes
 
        include apt              # Install and run apt 

- Force an apt-get update before the installation on any package (this is very useful but can create dependency cycles in certain conditions)

        class { 'apt':
          force_aptget_update => true,
        }


- Add config via source

        apt::conf { '10periodic':
          ensure => present,
          source => 'puppet:///modules/apt/10periodic',
        }

- Add config via content

        apt::conf{ '99unattended-upgrade':
          ensure  => present,
          content => "APT::Periodic::Unattended-Upgrade \"1\";\n",
        }

- Set automatic unattended security updates

        apt::unattended_upgrade_automatic{ 'updates':
          mail => 'boian.mihailov@cvalka.com',
        }


[![Build Status](https://travis-ci.org/example42/puppet-apt.png?branch=master)](https://travis-ci.org/example42/puppet-apt)
