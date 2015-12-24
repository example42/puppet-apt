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
  # This file is shipped since version 0.83.4
  file {
    '/etc/kernel/postinst.d/unattended-upgrades':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      source  => 'puppet:///modules/apt/unattended-upgrades.kernel-postinst',
      require => Package['unattended-upgrades'],
  }
}
