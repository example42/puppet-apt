# =Define: apt::unattended_upgrade_automatic
#
# This define configures APT unattended upgrades
#
#
# == Parameters
#
# [*mail*]
#   E-mail address to which send reports
#
#
# == Examples
#
# Usage:
#  apt::unattended_upgrade_automatic { }
#
#
define apt::unattended_upgrade_automatic($mail = '') {

  include apt::unattended_upgrade

  apt::conf{ 'unattended-upgrade':
    ensure   => present,
    content  => "APT::Periodic::Unattended-Upgrade \"1\";\n",
    priority => '99',
  }

  apt::conf { 'periodic':
    ensure   => present,
    source   => 'puppet:///modules/apt/10periodic',
    priority => '10',
  }

  case $::lsbdistid {
    'Debian': {
      apt::conf { 'unattended-upgrades':
        ensure   => present,
        content  => template("apt/unattended-upgrades.${::lsbdistcodename}.erb"),
        priority => '50',
      }
    }
    'Ubuntu': {
      apt::conf { 'unattended-upgrades':
        ensure   => present,
        content  => template("apt/unattended-upgrades.${::lsbdistid}.erb"),
        priority => '50',
      }
    }
    default: {}
  }

}
