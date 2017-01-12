# = Class: apt::repo::mesosphere
#
class apt::repo::mesosphere {

  case $::operatingsystem {
    'Ubuntu': {
      apt::repository { 'mesosphere':
        url        => 'http://repos.mesosphere.io/ubuntu',
        distro     => $::lsbdistcodename,
        repository => 'main',
        key        => 'E56151BF',
        keyserver  => 'keyserver.ubuntu.com',
      }
    }
    'Debian': {
      apt::repository { 'mesosphere':
        url        => 'http://repos.mesosphere.io/debian',
        distro     => $::lsbdistcodename,
        repository => 'main',
        key        => 'E56151BF',
        keyserver  => 'keyserver.ubuntu.com',
      }
    }
    default: { fail("${::hostname}: This module does not support operatingsystem ${::operatingsystem}") }
  }
}
