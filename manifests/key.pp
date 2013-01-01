# Define: apt::key
#
# Add key to keyring
#
# Usage:
#  apt::key { "key id":
#    url => 'key url',
#  }
#
define apt::key (
  $url         = '',
  $environment = undef,
  $path        = '/usr/sbin:/usr/bin:/sbin:/bin',
  $keyserver   = '',
  $fingerprint = ''
) {

  if $url != '' {
    exec { "aptkey_add_${name}":
      command     => "wget -O - ${url} | apt-key add -",
      unless      => "apt-key list | grep -q ${name}",
      environment => $environment,
      path        => $path,
    }
  } else {
    exec { "aptkey_adv_${name}":
      command     => "apt-key adv --keyserver ${keyserver} --recv ${fingerprint}",
      unless      => "apt-key list | grep -q ${name}",
      environment => $environment,
      path        => $path,
    }
  }
}
