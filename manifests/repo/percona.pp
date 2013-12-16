# = Class: apt::repo::percona
#
# This class installs the Percona repo
#
class apt::repo::percona {

  apt::repository { 'percona':
    url        => 'http://repo.percona.com/apt',
    distro     => $::lsbdistcodename,
    repository => 'main',
    key        => 'CD2EFD2A',
  }

}
