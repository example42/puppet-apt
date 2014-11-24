# =Define: apt::unattended_upgrade_automatic
#
# This define configures APT unattended upgrades
#
#
# == Parameters
#
# [*mail*]
#   E-mail address to which send reports, default don't send emails.
# [*mailonlyerror*]
#   Set this value to "true" to get emails only on errors. Default
#   is to always send a mail if mail is set.
# [*repository*]
#   Array of extra repository to be added for unattended-upgreades,
#   each line will be reported on the unattended-upgrades conf file example:
#   origin=Puppetlabs,archive=wheezy,label=Puppetlabs
# [*blacklist*]
#   Array of packages that you don't want to automatically update
#   each line must contain the name of a package example:
#
#     - vim
#     - mysql-server
#     - tomcat
# [*automaticreboot*]
#   Boolean, default if not set is false, if set to true the system
#   will reboot if necessarry at automatictime
# [*automatictime*]
#   You can set the time of the reboot, default it's 02:00
#
# == Examples
#
# Usage:
#  apt::unattended_upgrade_automatic { }
#
#
define apt::unattended_upgrade_automatic(
  $mail            = '',
  $mailonlyerror   = '',
  $repository      = '',
  $blacklist       = '',
  $automaticreboot = '',
  $automatictime   = '',

) {

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
    'Debian','Ubuntu': {
      file { '50unattended-upgrades':
        ensure  => file,
        path    => "${apt::aptconfd_dir}/50unattended-upgrades",
        content => template("apt/unattended-upgrades.${::lsbdistid}.erb"),
        mode    => $apt::config_file_mode,
        owner   => $apt::config_file_owner,
        group   => $apt::config_file_group,
        require => Package[$apt::package],
        before  => Exec['aptget_update'],
        notify  => Exec['aptget_update'],
        audit   => $apt::manage_audit,
      }
    }
    default: {}
  }

}
