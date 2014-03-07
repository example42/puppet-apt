# = Class: apt::repo::rabbitmq
#
# This class installs the rabbitmq repo
#
class apt::repo::rabbitmq {

  apt::source { 'rabbitmq':
    url             => 'http://http://www.rabbitmq.com/debian/',
    distro          => $::lsbdistcodename,
    repository      => 'main',
    key_url         => 'http://www.rabbitmq.com/rabbitmq-signing-key-public.asc',
    key             => '056E8E56',
    keyserver       => 'keys.gnupg.net',
  }

}

