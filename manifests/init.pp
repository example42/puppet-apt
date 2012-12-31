# = Class: apt
#
# Manages apt.
#
#
# Include it to install and run apt
# It defines package, service, main configuration file.
#
# Usage:
# include apt
#
class apt (
  $update_command      = params_lookup( 'update_command' ),
  $my_class            = params_lookup( 'my_class' ),
  $source              = params_lookup( 'source' ),
  $source_dir          = params_lookup( 'source_dir' ),
  $source_dir_purge    = params_lookup( 'source_dir_purge' ),
  $template            = params_lookup( 'template' ),
  $options             = params_lookup( 'options' ),
  $version             = params_lookup( 'version' ),
  $absent              = params_lookup( 'absent' ),
  $audit_only          = params_lookup( 'audit_only' , 'global' ),
  $package             = params_lookup( 'package' ),
  $config_dir          = params_lookup( 'config_dir' ),
  $config_file         = params_lookup( 'config_file' )
  ) inherits apt::params {

  ### Internal variables setting
  # Configurations directly retrieved from apt::params
  $config_file_mode=$apt::params::config_file_mode
  $config_dir_mode=$apt::params::config_dir_mode
  $config_file_owner=$apt::params::config_file_owner
  $config_file_group=$apt::params::config_file_group

  $aptconf_dir = "${config_dir}/apt.conf.d"
  $sourcelist = "${config_dir}/sources.list"
  $sourcelist_dir = "${config_dir}/sources.list.d"
  $preferences_dir = "${config_dir}/preferences.d"


  # Sanitize of booleans
  $bool_source_dir_purge=any2bool($source_dir_purge)
  $bool_absent=any2bool($absent)
  $bool_audit_only=any2bool($audit_only)

  # Logic management according to parameters provided by users
  $manage_package = $apt::bool_absent ? {
    true  => 'absent',
    false => $apt::version,
  }
  $manage_file = $apt::bool_absent ? {
    true    => 'absent',
    default => 'present',
  }
  $manage_audit = $apt::bool_audit_only ? {
    true  => 'all',
    false => undef,
  }
  $manage_file_replace = $apt::bool_audit_only ? {
    true  => false,
    false => true,
  }
  $manage_file_source = $apt::source ? {
    ''        => undef,
    default   => $apt::source,
  }
  $manage_file_content = $apt::template ? {
    ''        => undef,
    default   => template($apt::template),
  }

  ### Resources managed by the module
  package { $apt::package:
    ensure => $apt::manage_package,
  }

  file { 'apt.conf':
    ensure  => $apt::manage_file,
    path    => $apt::config_file,
    mode    => $apt::config_file_mode,
    owner   => $apt::config_file_owner,
    group   => $apt::config_file_group,
    require => Package[$apt::package],
    source  => $apt::manage_file_source,
    content => $apt::manage_file_content,
    notify  => Exec['aptget_update'],
    replace => $apt::manage_file_replace,
    audit   => $apt::manage_audit,
  }

  # The whole apt configuration directory is managed only
  # if $apt::source_dir is provided
  if $apt::source_dir and $apt::config_dir != '' {
    file { 'apt.dir':
      ensure  => directory,
      path    => $apt::config_dir,
      require => Package[$apt::package],
      source  => $apt::source_dir,
      notify  => Exec['aptget_update'],
      recurse => true,
      purge   => $apt::bool_source_dir_purge,
      force   => $apt::bool_source_dir_purge,
      replace => $apt::manage_file_replace,
      audit   => $apt::manage_audit,
    }
  }

  apt::conf { 'update_trigger':
    content => "// File managed by Puppet. Triggers an apt-get update on first run\n",
  }

  exec { 'aptget_update':
    command     => $apt::update_command,
    logoutput   => false,
    refreshonly => true,
  }

  ### Include custom class if $my_class is set
  if $apt::my_class {
    include $apt::my_class
  }

}
