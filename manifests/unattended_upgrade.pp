class apt::unattended_upgrade {
  package { 'unattended-upgrades':
    ensure => present,
  }
}
