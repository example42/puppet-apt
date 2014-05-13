# = Class: apt::repo::backports
#
class apt::repo::backports(
  $url = 'http://cdn.debian.net/debian/',
  $distro = "${::lsbdistcodename}-backports",
  $component = 'main',
) {

  apt::repository { 'backports':
    url             => $url,
    distro          => $distro,
    repository      => $component,
  }

}

