# Define apt::conf
#
define apt::conf (
  $source    = '' ,
  $content   = '' ,
  $prioritty = '10' ,
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
    path    => "${apt::aptconf_dir}/${priority}${name}.conf",
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
