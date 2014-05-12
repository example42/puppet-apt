class apt::repo::proliant_mcp ($distro = $::lsbdistcodename) {

  apt::repository { 'proliant_mcp':
    url        => 'http://downloads.linux.hp.com/SDR/repo/mcp',
    distro     => "${distro}/current",
    repository => 'non-free',
    key        => '2689B887',
    key_url    => 'http://downloads.linux.hp.com/SDR/repo/mcp/GPG-KEY-mcp';
  }

}
