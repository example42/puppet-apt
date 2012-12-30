# Define apt::conf
#
# General apt main configuration file's inline modification define
# Use with caution, it's still at experimental stage and may break in untested circumstances
# Engine, pattern end line parameters can be tweaked for better behaviour
#
# Usage:
# apt::conf    { "mynetworks":  value => "127.0.0.0/8 10.42.42.0/24" }
#
define apt::conf (
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

  file { "apt_conf_$name":
    ensure  => $ensure,
    path    => "${apt::aptconf_dir}/${name}.conf",
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
