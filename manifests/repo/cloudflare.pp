# = Class: apt::repo::cloudflare
#
class apt::repo::cloudflare {

  apt::repository { 'cloudflare':
    url        => 'http://pkg.cloudflare.com/',
    distro     => $::lsbdistcodename,
    repository => 'main',
    key_url    => 'https://pkg.cloudflare.com/pubkey.gpg',
  }

}
