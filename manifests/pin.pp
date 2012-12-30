# Define: apt::pin
#
# Pinning packages
#
# Usage:
#  apt::pin { "packageName":
#    version  => "version to pin (optional)",
#    release  => "release to pin (optional)",
#    priority => "pin priority",
#  }
#
# You need to set at least version or release to pin and not both.
# You can provide also a custom template and polulate it as you want:
#   apt::pin { "cassandra":
#     template => 'my_site/apt/pin.erb',
#   }
#
# For example, to forcing installation of cassandra 0.7.5, you can pin it:
#
#   apt::pin { "cassandra":
#     version  => "0.7.5",
#     priority => "1001",
#   } 
#
# Or, you can force installation of firefox from the intrepid release
#
#  apt::pin { "firefox-3.0":
#    release  => "intrepid",
#    priority => "900",
#  }
#
# Alternatively can provide a custom template and populate it as you want:
#   apt::pin { "cassandra":
#     template => 'my_site/apt/pin.erb',
#   }
#
define apt::pin ( 
  $version  = '',
  $release  = '',
  $priority = '',
  $template = '',
  $ensure   = 'present'
) {

  include apt

  $manage_file_content = $content ? {
    ''        => $version ? {
      ''      => 'apt/pin-release.erb',
      default => 'apt/pin-version.erb',
    default   => $content,
  }

  file { "apt_pin_$name":
    ensure  => $ensure,
    path    => "${apt::preferences_dir}/pin-${name}",
    mode    => $apt::config_file_mode,
    owner   => $apt::config_file_owner,
    group   => $apt::config_file_group,
    require => Package[$apt::package],
    before  => Exec['aptget_update'],
    notify  => Exec['aptget_update'],
    content => $manage_file_content,
    audit   => $apt::manage_audit,
  }

}
