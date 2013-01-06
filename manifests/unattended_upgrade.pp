# = Class: apt::unattended_upgrade
#
# Manages APT unattended upgrades.
# This will install the unattended-upgrades package
#
#
# == Parameters
#
#
# == Examples
#
# Usage:
# include apt::unattended_upgrade
#
#
class apt::unattended_upgrade {

  package { 'unattended-upgrades':
    ensure => present,
  }

}
