# = Class: apt::repo::debian_mozilla
#
# == Parameters
#
# [*distro*]
#   One of squeeze-backports, wheezy-backports or experimental.
#   See http://mozilla.debian.net/ for more information.
#
# [*component*]
#   One of iceweasel, iceweasel-esr, iceweasel-aurora, ...
#   See http://mozilla.debian.net/ for more information.
#
class apt::repo::debian_mozilla(
  $distro = "${::lsbdistcodename}-backports",
  $component = 'iceweasel',
) {

  apt::repository { 'debian_mozilla':
    url             => 'http://mozilla.debian.net/',
    distro          => $distro,
    repository      => $component,
    keyring_package => 'pkg-mozilla-archive-keyring',
  }

}

