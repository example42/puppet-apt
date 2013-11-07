# =Define: apt::source
#
# Add repository to sources.list.d in a way that's compatible with the Puppetlabs apt module
#
# Makes use of the apt::repository define to do the work
#
define apt::source (
  $ensure            = present,
  $location          = '',
  $release           = 'UNDEF',
  $repos             = 'main',
  $include_src       = true,
  $required_packages = false,
  $key               = false,
  $key_server        = undef,
  $key_content       = false, # TODO: not implemented yet
  $key_source        = false,
  $pin               = false, # TODO: not implemented yet
  $architecture      = undef, # TODO: not implemented yet
  ) {

  if $key != false {
    $key_real = $key
  } else {
    $key_real = ''
  }
  if $key_source != false {
    $key_source_real = $key_source
  } else {
    $key_source_real = ''
  }

  if $release == 'UNDEF' {
    if $::lsbdistcodename == undef {
      fail('lsbdistcodename fact not available: release parameter required')
    } else {
      $release_real = $::lsbdistcodename
    }
  } else {
    $release_real = $release
  }

  apt::repository {$title:
    url        => $location,
    distro     => $release_real,
    repository => $repos,
    src_repo   => false,
    key        => $key_real,
    key_url    => $key_source_real,
    keyserver  => $key_server,
  }

  if $include_src {
    apt::repository {"${title}-src":
      url        => $location,
      distro     => $release_real,
      repository => $repos,
      src_repo   => true,
      require    => Apt::Repository[$title],
    }
  }

  if ($required_packages != false) and ($ensure == 'present') {
    exec { "Required packages: '${required_packages}' for ${name}":
      command     => "/usr/bin/apt-get -y install ${required_packages}",
      logoutput   => 'on_failure',
      refreshonly => true,
      subscribe   => File["${name}.list"],
      before      => Exec['apt_update'],
    }
  }
}
# vim:shiftwidth=2:tabstop=2:softtabstop=2:expandtab:smartindent

