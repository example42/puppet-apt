class apt::repo::newrelic {

  apt::repository { 'newrelic':
    url        => 'http://apt.newrelic.com/debian',
    distro     => 'newrelic',
    repository => 'non-free',
    key        => '548C16BF',
  }

}

