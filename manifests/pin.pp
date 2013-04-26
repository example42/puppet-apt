# = Define: apt::pin
#
# Pinning packages
# See man apt_preferences for more details
#
#
# == Parameters
#
# [*name*]
#   Name of the pin to add. Implicit parameter
#   If you want to specify two or more pins for the same resource,
#   you can use it, like this:
#
#  apt::pin { 'firefox_intrepid':
#    name     => 'firefox',
#    type     => 'release',
#    value    => 'intrepid',
#    priority => "900",
#  }
#  apt::pin { 'firefox-4.5':
#    name     => 'firefox',
#    type     => 'version',
#    value    => '4.5.*',
#    priority => "501",
#  }
#
# [*type*]
#   One of the available pin types: origin, version or release
#   Default: version.
#
# [*value*]
#   The value to pin to. Depends on the choosen type.
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
#  apt::pin { "packageName":
#    type     => 'pin_type',
#    value    => 'pin criteria',
#    priority => 'pin priority',
#  }
#
# You need to set at least a value, in which case pin type defaults to "version"
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
  $type     = '',
  $value    = '',
  $priority = '',
  $template = '',
  $ensure   = 'present'
) {

  include apt

  $pin_type = $type ? {
    ''      => 'version',
    default => $type,
  }

  $manage_file_content = $template ? {
    ''        => 'apt/pin.erb',
    default   => $template,
  }

  file { "apt_pin_${title}":
    ensure  => $ensure,
    path    => "${apt::preferences_dir}/pin-${title}-${type}",
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
