define apt::unattended_upgrade_automatic($mail = '') {

  include apt::unattended_upgrade

  apt::conf{ '99unattended-upgrade':
    ensure  => present,
    content => "APT::Periodic::Unattended-Upgrade \"1\";\n",
  }

  apt::conf { '10periodic':
    ensure => present,
    source => 'puppet:///apt/10periodic',
  }

  case $lsbdistid {
    'Debian': {
      apt::conf{'50unattended-upgrades':
        ensure  => present,
        content => template("apt/unattended-upgrades.${lsbdistcodename}.erb"),
      }
    }
    'Ubuntu': {
      apt::conf{'50unattended-upgrades':
        ensure  => present,
        content => template("apt/unattended-upgrades.${lsbdistid}.erb"),
      }
    }
    default: {}
  }

}
