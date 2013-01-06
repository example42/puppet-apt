# = Define: apt::conf
#
# Add an APT configuration file.
#
#
# == Parameters
#
# [*name*]
#   Implicit parameter.
#   Name of the configuration to add
#
# [*source*]
#   Source (via puppet files) of the configuration to add
#
# [*content*]
#   Content (via templates) of the configuration to add
#
# [*priority*]
#   Priority of the configuration to add, defaults to 10
#
# [*ensure*]
#   Whether to add or delete this configuration
#
#
# == Examples
#
# Usage:
# apt::conf { 'DisablePdiff':
#   content  => 'Acquire::PDiffs "false";',
#   priority => '99',
# }
#
#
define apt::conf (
  $source    = '' ,
  $content   = '' ,
  $priority  = '10' ,
  $ensure    = present ) {

  include apt

  $manage_file_source = $source ? {
    ''        => undef,
    default   => $source,
  }

  $manage_file_content = $content ? {
    ''        => undef,
    default   => $content,
  }

  file { "apt_conf_${name}":
    ensure  => $ensure,
    path    => "${apt::aptconfd_dir}/${priority}${name}.conf",
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
