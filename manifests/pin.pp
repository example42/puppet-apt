# = Define: apt::pin
#
# Pinning packages
# See man apt_preferences for more details
#
#
# == Parameters
#
# [*package*]
#   Name of the package. If empty, defaults to $name
#   If you want to specify two or more pins for the same resource,
#   you can use it, like this:
#
#  apt::pin { 'firefox_intrepid':
#    package  => 'firefox',
#    type     => 'release',
#    value    => 'intrepid',
#    priority => "900",
#  }
#  apt::pin { 'firefox-4.5':
#    package  => 'firefox',
#    type     => 'version',
#    value    => '4.5.*',
#    priority => "501",
#  }
#
# [*version*]
#   Format:
#    version => '4.5.*',
#   can be specified as a shorthand for:
#    type     => 'version',
#    value    => '4.5.*',
#
# [*release*]
#   Format:
#    release => 'intrepid',
#   can be specified as a shorthand for:
#     type     => 'release',
#     value    => 'intrepid',
#
# [*origin*]
#   Format:
#    origin => 'ftp.debian.org',
#   can be specified as a shorthand for:
#     type     => 'origin',
#     value    => 'ftp.debian.org',
#
# [*type*]
#   One of the available pin types: origin, version or release
#   If none of the shorthands nor type is specified, defaults to [*version*].
#
# [*value*]
#   The value to pin to. Depends on the choosen type.
#   If none specified, defaults to "*".
#   IE:
#    type  => 'version'
#    value => '5.8*'
#
#    type  => 'release'
#    value => 'a=stable, v=7.0'
#
# [*priority*]
#   Priority of the configuration to add
#
# [*template*]
#   Custom template to use, instead of the default one
#
# [*ensure*]
#   Whether to add or delete this pin
#
#
# == Examples
#
# Usage:
# Short form:
# You need to set at least version, release or origin to pin.
# Can't specify more than one.
#
#  apt::pin { "packageName":
#    version  => "version to pin (optional)",
#    release  => "release to pin (optional)",
#    origin   => "origin  to pin (optional)",
#    priority => "pin priority",
#
# Complete form:
# You need to set at least a value, in which case pin type defaults to "version"
#
#  apt::pin { "packageName":
#    type     => 'pin_type',
#    value    => 'pin criteria',
#    priority => 'pin priority',
#  }
#
#
# You can provide also a custom template and populate it as you want:
#   apt::pin { "cassandra":
#     template => 'my_site/apt/pin.erb',
#   }
#
# For example, to forcing installation of cassandra 0.7.5, you can pin it:
#
#   apt::pin { 'cassandra':
#     type     => 'version',
#     value    => '0.7.5',
#     priority => '1001',
#   }
#
# Or, you can force installation of firefox from the intrepid release
#
#  apt::pin { 'firefox-3.0':
#    type     => 'release',
#    value    => 'intrepid',
#    priority => "900",
#  }
#
# Alternatively can provide a custom template and populate it as you want:
#   apt::pin { "cassandra":
#     template => 'my_site/apt/pin.erb',
#   }
#
define apt::pin (
  $package  = '',
  $type     = '',
  $value    = '',
  $priority = '',
  $template = '',
  $version  = '',
  $release  = '',
  $origin   = '',
  $ensure   = 'present'
) {

  include apt

  $real_package = $package ? {
    ''      => $name,
    default => $package,
  }

  ### Handle shorthands
  if $origin != '' {
    $real_type = 'origin'
    $real_value = $origin
  }

  if $release != '' {
    $real_type = 'release'
    $real_value = $release
  }

  if $version != '' {
    $real_type = 'version'
    $real_value = $version
  }

  # If no shorthand succeded, we evaluate $type and $value
  if $real_type == undef {
    $real_type = $type ? {
      ''      => 'version',
      default => $type,
    }
  }

  if $real_value == undef {
    $real_value = $value ? {
      ''      => '*',
      default => $value,
    }
  }

  $manage_file_content = $template ? {
    ''        => 'apt/pin.erb',
    default   => $template,
  }

  file { "apt_pin_${name}":
    ensure  => $ensure,
    path    => "${apt::preferences_dir}/pin-${name}-${real_type}",
    mode    => $apt::config_file_mode,
    owner   => $apt::config_file_owner,
    group   => $apt::config_file_group,
    require => Package[$apt::package],
    before  => Exec['aptget_update'],
    notify  => Exec['aptget_update'],
    content => template($manage_file_content),
    audit   => $apt::manage_audit,
  }
}
