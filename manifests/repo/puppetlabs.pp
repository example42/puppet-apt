# = Class: apt::repo::puppetlabs
#
class apt::repo::puppetlabs ($distro = $::lsbdistcodename, $dependencies = true) {
  apt::repository { 'puppetlabs':
    url        => 'http://apt.puppetlabs.com',
    distro     => $distro,
    repository => 'main',
    # key      => '1054B7A24BD6EC30',
    key        => '4BD6EC30',
  }

  if $dependencies {
    apt::repository { 'puppetlabs-dependencies':
      url        => 'http://apt.puppetlabs.com',
      distro     => $distro,
      repository => 'dependencies',
      # key      => '1054B7A24BD6EC30',
      key        => '4BD6EC30',
    }
  }
}

