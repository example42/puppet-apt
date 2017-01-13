# = Class: apt::repo::gocd
#
class apt::repo::gocd {
  ensure_packages('apt-transport-https')
  apt::repository { 'gocd':
    url        => 'https://download.go.cd',
    repository => '/',
    key_url    => 'https://download.go.cd/GOCD-GPG-KEY.asc',
  }

}
