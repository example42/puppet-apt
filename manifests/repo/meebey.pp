# experimental mono packages for debian
class apt::repo::meebey {
  apt::repository { 'meebey':
    url        => 'http://debian.meebey.net/experimental/mono',
    distro     => '',
    repository => '/',
  }
}

