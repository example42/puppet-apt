# = Class: apt::repo::postgresql
#
# This class installs the postgresql repo
#
class apt::repo::postgresql {

  case $::operatingsystem {
  Ubuntu: {
    apt::repository { 'postgresql':
      url             => 'http://apt.postgresql.org/pub/repos/apt',
      distro          => "${::lsbdistcodename}-pgdg",
      repository      => 'main',
      key_url         => 'https://www.postgresql.org/media/keys/ACCC4CF8.asc',
      key             => 'ACCC4CF8',
      keyring_package => 'pgdg-keyring',

    }
  }
  Debian: {
    apt::repository { 'postgresql':
      url             => 'http://apt.postgresql.org/pub/repos/apt',
      distro          => "${::lsbdistcodename}-pgdg",
      repository      => 'main',
      key_url         => 'https://www.postgresql.org/media/keys/ACCC4CF8.asc',
      key             => 'ACCC4CF8',
      keyring_package => 'pgdg-keyring',
    }
  }
  default: {}
  }

}

