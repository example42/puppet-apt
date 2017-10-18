# = Class: apt::repo::docker
#
# This class installs the Docker repo
#
class apt::repo::docker(
  $repos = 'stable',
) {
  ensure_packages('apt-transport-https')
  case $::operatingsystem {
  'Debian': {
    apt::source { 'docker':
      location => 'https://download.docker.com/linux/debian',
      release  => $::lsbdistcodename,
      repos    => $repos,
      key      => {
        # From https://download.docker.com/linux/debian/gpg
        'id'      => '9DC858229FC7DD38854AE2D88D81803C0EBFCD88',
        'content' => file('apt/repo/docker.gpg'),
      },
    }
  }
  'Ubuntu': {
    apt::source { 'docker':
      location => 'https://download.docker.com/linux/ubuntu',
      release  => $::lsbdistcodename,
      repos    => $repos,
      key      => {
        # From https://download.docker.com/linux/debian/gpg
        'id'      => '9DC858229FC7DD38854AE2D88D81803C0EBFCD88',
        'content' => file('apt/repo/docker.gpg'),
      },
    }
  }
  default: {}
  }

}
