# = Class: apt::repo::dockerproject
#
# This class installs the Docker repo
#
class apt::repo::dockerproject {

  case $::operatingsystem {
  'Debian': {
    apt::repository { 'docker':
      url        => 'https://apt.dockerproject.org/repo',
      distro     => "debian-${::lsbdistcodename}",
      repository => 'main',
      key        => '58118E89F3A912897C070ADBF76221572C52609D',
      key_url    => 'https://apt.dockerproject.org/gpg';
    }
  }
  'Ubuntu': {
    apt::repository { 'docker':
      url        => 'https://apt.dockerproject.org/repo',
      distro     => "ubuntu-${::lsbdistcodename}",
      repository => 'main',
      key        => '58118E89F3A912897C070ADBF76221572C52609D',
      key_url    => 'https://apt.dockerproject.org/gpg';
    }
  }
  default: {}
  }

}
