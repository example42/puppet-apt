# = Class: apt::repo::openstack
#
# This class installs the openstack repo
#
class apt::repo::openstack_grizzly (
  $release = 'grizzly'
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

