# = Class: apt::repo::hhvm
#
class apt::repo::hhvm {

  case $::operatingsystem {
    Ubuntu: {
      apt::repository { 'hhvm':
        url        => 'http://dl.hhvm.com/ubuntu',
        distro     => $::lsbdistcodename,
        repository => 'main',
        key        => '1BE7A449',
        key_url    => 'http://dl.hhvm.com/conf/hhvm.gpg.key',
      }
    }
    Mint: {
      apt::repository { 'hhvm':
        url        => 'http://dl.hhvm.com/mint',
        distro     => $::lsbdistcodename,
        repository => 'main',
        key        => '1BE7A449',
        key_url    => 'http://dl.hhvm.com/conf/hhvm.gpg.key',
      }
    }
    Debian: {
      apt::repository { 'hhvm':
        url        => 'http://dl.hhvm.com/debian',
        distro     => $::lsbdistcodename,
        repository => 'main',
        key        => '1BE7A449',
        key_url    => 'http://dl.hhvm.com/conf/hhvm.gpg.key',
      }
    }
    default: { fail("${::hostname}: This module does not support operatingsystem ${::operatingsystem}") }
  }
}


