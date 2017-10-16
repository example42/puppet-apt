# Puppet module: apt

Puppet module to manage apt

Originally written by Boian Mihailov - boian.mihailov@gmail.com
Added features by Marco Bonetti
Adapted to Example42 NextGen layout by Alessandro Franceschi
Currently maintained by [Mathieu Parent](https://github.com/sathieu)

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


It also contains functionality to use [apt-dater](https://github.com/DE-IBH/apt-dater) to manage centrally controlled updates via ssh on deb-based and yum-based systems.

## USAGE

- Standard Classes
 
        include apt              # Install and run apt 

- DO NOT Force an apt-get update before the installation on any package (this is very useful for seamless packages installations). Default true, set to false if you have dependency cycles (or place the apt class in earlier stages)

        class { 'apt':
          force_aptget_update => false,
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

- Configure a host to be controlled by apt-dater

        class { 'apt::dater':
          customer => 'ACME Corp.',
          ssh_key_type => 'ssh-rsa',
          ssh_key => template('site/apt-dater.pub.key');
        }

- Configure an apt-dater controller (no self-management) for root

        class { 'apt::dater':
          role => 'manager',
          manager_ssh_key => template('site/apt-dater.priv.key');
        }

- Handle dpkg-statoverride

	apt::dpkg_statoverride { '/var/log/puppet':
	  user  => 'puppet',
	  group => 'puppet',
	  mode  => '750',
	}

- Manage apt keys (Compatible with [puppetlabs-apt](https://forge.puppet.com/puppetlabs/apt)

    apt::key { 'key id':
      source => 'key url',
      server => 'keyserver.net',
      id     => 'key fingerprint'
    }

- Manage sources-list.d entries

    Add repository to sources.list.d in a way that's compatible with the Puppetlabs apt module

    apt::source { 'source':
      ensure      => present,
      comment     => 'another source',
      location    => 'http://myrepo.net/path',
      release     => 'jessie',
      repos       => 'main',
      include_srv => true,
      key         => 'key',
      keyserver   => 'keyserver.net',
    }

- Manage ppa repositories

    apt::ppa { 'ppa:freetuxtv/freetuxtv'
      release          => 'trusty',
    }

- Manage package pinning

    apt::pin { 'firefox_intrepid':
      package  => 'firefox',
      type     => 'release',
      value    => 'intrepid',
      priority => "900",
    }


[![Build Status](https://travis-ci.org/example42/puppet-apt.png?branch=master)](https://travis-ci.org/example42/puppet-apt)
