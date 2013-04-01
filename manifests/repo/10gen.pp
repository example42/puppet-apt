# = Class: apt::repo::10gen
#
# This class installs the 10gen repo for MongoDB
#
class apt::repo::10gen {

  case $::operatingsystem {
  Ubuntu: {
    apt::repository { '10gen':
      url        => 'http://downloads-distro.mongodb.org/repo/ubuntu-upstart',
      distro     => 'dist',
      repository => '10gen',
      key        => '7F0CEB10',
    }
  }
  Debian: {
    apt::repository { '10gen':
      url        => 'http://downloads-distro.mongodb.org/repo/debian-sysvinit',
      distro     => 'dist',
      repository => '10gen',
      key        => '7F0CEB10',
    }
  }
  default: {}
  }

}
