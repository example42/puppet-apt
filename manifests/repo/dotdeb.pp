# = Class: apt::repo::dotdeb
#
# This class installs the dotdeb repo
#
class apt::repo::dotdeb {

  case $::operatingsystem {
  Debian: {
    apt::repository { 'dotdeb':
      url        => 'http://packages.dotdeb.org/',
      distro     => $::lsbdistcodename,
      repository => 'all',
      key        => '89DF5277',
    }
  }
  default: {}
  }

}
