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
  $keyserver       = 'subkeys.pgp.net',
  $fingerprint     = ''
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
