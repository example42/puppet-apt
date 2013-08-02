# = Class: apt::repo::cuttlefish
#
# This class installs the cuttlefish repo
#
class apt::repo::cuttlefish {

  apt::repository { 'cuttlefish':
    url             => 'http://ceph.com/debian-cuttlefish/',
    distro          => $::lsbdistcodename,
    repository      => 'main',
    key_url         => 'https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc',
    key             => '17ED316D',
  }

}

