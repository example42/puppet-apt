# = Define: apt::key
#
# Add an APT key to keyring.
#
#
# == Parameters
#
# [*name*]
#   Implicit parameter.
#   Name of the key to add
#
# [*url*]
#   Url from which fetch the key
#
# [*environment*]
#   Environment to pass to the executed commands
#
# [*path*]
#   Path to pass to the executed commands
#
# [*keyserver*]
#   Key server from which retrieve the key
#
# [*fingerprint*]
#   Fingerprint of the key to retrieve
#
#
# == Examples
#
# Usage:
#  apt::key { "key id":
#    url => 'key url',
#  }
#
#
define apt::key (
  $url             = '',
  $environment     = undef,
  $path            = '/usr/sbin:/usr/bin:/sbin:/bin',
  $keyserver       = '',
  $fingerprint     = ''
) {

  include apt

  $real_keyserver = $keyserver ? {
    ''      => $apt::keyserver,
    default => $keyserver,
  }

  if $url != '' {
    exec { "aptkey_add_${name}":
      command     => "wget -O - ${url} | apt-key add -",
      unless      => "apt-key adv --list-public-keys --with-fingerprint --with-colons | grep -q ${name}",
      environment => $environment,
      path        => $path,
    }
  } else {
    exec { "aptkey_adv_${name}":
      command     => "apt-key adv --keyserver ${real_keyserver} --recv ${fingerprint}",
      unless      => "apt-key adv --list-public-keys --with-fingerprint --with-colons | grep -q ${name}",
      environment => $environment,
      path        => $path,
    }
  }

}
