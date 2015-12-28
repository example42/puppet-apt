# =Define: apt::unattended_upgrade_automatic
#
# This define configures APT unattended upgrades
#
#
# == Parameters
#
# [*mail*]
#   E-mail address to which send reports#
#
# [*mailonlyerror*]
#   Set this value to "true" to get emails only on errors. Default
#   is to always send a mail if mail is set.
#
# [*repository*]
#   Array of extra repository to be added for unattended-upgreades,
#   each line will be reported on the unattended-upgrades conf file example:
#   origin=Puppetlabs,archive=wheezy,label=Puppetlabs
#
# [*blacklist*]
#   Array of packages that you don't want to automatically update
#   each line must contain the name of a package example:
#
#     - vim
#     - mysql-server
#     - tomcat
#
# [*automaticremove*]
#   Boolean, do automatic removal of new unused dependencies after the upgrade
#   (equivalent to apt-get autoremove), default is false.
#
# [*automaticreboot*]
#   Boolean, default if not set is false, if set to true the system
#   will reboot if necessarry at automatictime, default is false
#
# [*automatictime*]
#   You can set the time of the reboot, default it's 02:00
#
# [*unattendedfilesuffix*]
#   Suffix to be used for the unattended file name, default .conf
#
# == Examples
#
# Usage:
#  apt::unattended_upgrade_automatic { }
#
#
define apt::unattended_upgrade_automatic(
  $mail                 = '',
  $mailonlyerror        = '',
  $repository           = [],
  $blacklist            = [],
  $automaticremove      = '',
  $automaticreboot      = '',
  $automatictime        = '',
  $unattendedfilesuffix = '.conf'

) {

  include apt::unattended_upgrade

  apt::conf{ 'unattended-upgrade':
    ensure   => present,
    content  => "APT::Periodic::Unattended-Upgrade \"1\";\n",
    priority => '99',
    suffix   => $unattendedfilesuffix,
  }

  apt::conf { 'periodic':
    ensure   => present,
    source   => 'puppet:///modules/apt/10periodic',
    priority => '10',
    suffix   => $unattendedfilesuffix,
  }

  case $::lsbdistid {
    'Debian','Ubuntu': {
      apt::conf { 'unattended-upgrades':
        ensure               => present,
        content              => template("apt/unattended-upgrades.${::lsbdistid}.erb"),
        priority             => '50',
        suffix               => $unattendedfilesuffix,
        notify_aptget_update => false,
        require              => Package['unattended-upgrades'],
      }
    }
    default: {}
  }

}
