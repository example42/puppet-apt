# = Class: apt::repo::ceph
#
# This class installs ceph repo
#
class apt::repo::ceph (
  $release = 'emperor',
) {

  apt::repository { "ceph-${release}":
    url             => "http://ceph.com/debian-${release}/",
    distro          => $::lsbdistcodename,
    repository      => 'main',
    # Official url breaks with wget and redirects. Used github equivalent
    # key_url         => 'https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc',
    key_url         => 'https://raw.github.com/ceph/ceph/master/keys/release.asc',
    key             => '17ED316D',
  }

}

