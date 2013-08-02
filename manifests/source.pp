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
  $required_packages = false,  # TODO: not implemented yet
  $key               = false,
  $key_server        = 'keyserver.ubuntu.com',  # TODO: not implemented yet
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

  apt::repository {$title:
    url        => $location,
    distro     => $release,
    repository => $repos,
    src_repo   => false,
    key        => $key_real,
    key_url    => $key_source_real,
  }
  
  if $include_src {
    apt::repository {"${title}-src":
      url        => $location,
      distro     => $release,
      repository => $repos,
      src_repo   => true,
      require    => Apt::Repository[$title],
    }
  }
}
# vim:shiftwidth=2:tabstop=2:softtabstop=2:expandtab:smartindent

