# =Define: apt::preferences
#
# Copy preferences to /etc/apt/preferences.d/ directory
#
#
# == Parameters
#
# [*name*]
#   Implicit parameter.
#   Name of the preference to add
#
# [*source*]
#   Source (via puppet files) of the preference to add
#
# [*content*]
#   Content (via templates) of the preference to add
#
# [*ensure*]
#   Whether to add or delete this preference
#
#
# == Examples
#
# Usage:
#  + install a preference file for "packagename"
#  apt::preferences { "packagename": }
#  + uninstall a preference file
#  apt::preferences { "packagename": enabled => false, }
#
define apt::preferences (
  $source  = '' ,
  $content = '' ,
  $ensure  = present ) {

  include apt
  $manage_file_source = $source ? {
    ''        => undef,
    default   => $source,
  }

  $manage_file_content = $content ? {
    ''        => undef,
    default   => $content,
  }

  file { "apt_preferences_${name}":
    ensure  => $ensure,
    path    => "${apt::preferences_dir}/${name}",
    mode    => $apt::config_file_mode,
    owner   => $apt::config_file_owner,
    group   => $apt::config_file_group,
    require => Package[$apt::package],
    before  => Exec['aptget_update'],
    notify  => Exec['aptget_update'],
    source  => $manage_file_source,
    content => $manage_file_content,
    audit   => $apt::manage_audit,
  }

}
