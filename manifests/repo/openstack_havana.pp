# = Class: apt::repo::openstack_havana
#
# This class installs the openstack repo
#
class apt::repo::openstack_havana (
  $release = 'havana'
  ) {

  case $::operatingsystem {
  Ubuntu: {
    apt::repository { "openstack_${release}":
      url             => 'http://ubuntu-cloud.archive.canonical.com/ubuntu',
      distro          => "${::lsbdistcodename}-updates/${release}",
      repository      => 'main',
      keyring_package => 'ubuntu-cloud-keyring',

    }
  }
  Debian: {
  }
  default: {}
  }

}

