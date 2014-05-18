# = Class: apt
#
# Manages apt.
#
#
# == Parameters
#
# Module specific parameters
#
# [*update_commad*]
#   Command to run to update index files listing available packages
#
# [*extra_packages*]
#   Extra packages to install, in addition of the one defined by the package parameter.
#   Can be a comma separated string, or an array.
#
# [*force_conf_d*]
#   Whether or not to delete the apt.conf file and only use the apt.conf.d directory
#
# [*force_sources_list_d*]
#   Whether or not to delete the sources.list file and only use the sources.list.d directory
#
# [*force_preferences_d*]
#   Whether or not to delete the preferences file and only use preferences.d directory
#
# [*force_aptget_update*]
#   Define if you want to trigger an apt-get update before installing ANY package.
#   Default: true, if you have dependency issues you might need to set this to false
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*my_class*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, apt class will automatically "include $my_class"
#   Can be defined also by the (top scope) variable $apt_my_class
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, apt main config file will have the param: source => $source
#   Can be defined also by the (top scope) variable $apt_source
#
# [*source_dir*]
#   If defined, the whole apt configuration directory content is retrieved
#   recursively from the specified source
#   (source => $source_dir , recurse => true)
#   Can be defined also by the (top scope) variable $apt_source_dir
#
# [*source_dir_purge*]
#   If set to true (default false) the existing configuration directory is
#   mirrored with the content retrieved from source_dir
#   (source => $source_dir , recurse => true , purge => true)
#   Can be defined also by the (top scope) variable $apt_source_dir_purge
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, apt main config file has: content => content("$template")
#   Note source and template parameters are mutually exclusive: don't use both
#   Can be defined also by the (top scope) variable $apt_template
#
# [*content*]
#   Defines the content of the main configuration file, to be used as alternative
#   to template when the content is populated on other ways.
#   If defined, apt main config file has: content => $content
#   Note: source, template and content are mutually exclusive.
#   If a template is defined, that has precedence on the content parameter
#
# [*options*]
#   An hash of custom options to be used in templates for arbitrary settings.
#   Can be defined also by the (top scope) variable $aptn_options
#
# [*version*]
#   The package version, used in the ensure parameter of package type.
#   Default: present. Can be 'latest' or a specific version number.
#   Note that if the argument absent (see below) is set to true, the
#   package is removed, whatever the value of version parameter.
#
# [*absent*]
#   Set to 'true' to remove package(s) installed by module
#   Can be defined also by the (top scope) variable $apt_absent
#
# [*audit_only*]
#   Set to 'true' if you don't intend to override existing configuration files
#   and want to audit the difference between existing files and the ones
#   managed by Puppet.
#   Can be defined also by the (top scope) variables $apt_audit_only
#   and $audit_only
#
# Default class params - As defined in apt::params.
# Note that these variables are mostly defined and used in the module itself,
# overriding the default values might not affected all the involved components.
# Set and override them only if you know what you're doing.
# Note also that you can't override/set them via top scope variables.
#
# [*package*]
#   The name of apt package
#
# [*config_dir*]
#   Main configuration directory. Used by puppi
#
# [*config_file*]
#   Main configuration file path
#
# [*sourceslist_file*]
#   The sources.list file path
#
# [*sourceslist_template*]
#   Sets the path to the template to use as content for the sources.list main file
#   If defined, sources.list file has: content => content("$template")
#
# [*sourceslist_content*]
#   Sets the content for the sources.list main file. Alternative to $template.
#   If defined, sources.list file has: content => $content
#
# [*preferences_file*]
#   The preferences file path
#
# [*preferences_template*]
#   Sets the path to the template to use as content for the preferences main file
#   If defined, preferences file has: content => content("$template")
#
# [*preferences_content*]
#   Sets the content for the preferences main file. Alternative to $preferences_template.
#   If defined, preferences file has: content => $content
#
# [*aptconfd_dir]
#   The apt.conf.d directory
#
# [*sourceslist_dir]
#   The sources.list.d directory
#
# [*preferences_dir]
#   The preferences.d directory
#
# [*config_file_mode*]
#   Main configuration file path mode
#
# [*config_file_owner*]
#   Main configuration file path owner
#
# [*config_file_group*]
#   Main configuration file path group
#
#
# == Examples
#
# Include it to install and run apt
# It defines package, service, main configuration file.
#
# Usage:
# include apt
#
# See README for details.
#
#
# == Author
#   Alessandro Franceschi <al@lab42.it/>
#
class apt (
  $update_command       = params_lookup( 'update_command' ),
  $extra_packages       = params_lookup( 'extra_packages' ),
  $force_conf_d         = params_lookup( 'force_conf_d' ),
  $purge_conf_d         = params_lookup( 'purge_conf_d' ),
  $force_sources_list_d = params_lookup( 'force_sources_list_d' ),
  $purge_sources_list_d = params_lookup( 'purge_sources_list_d' ),
  $force_preferences_d  = params_lookup( 'force_preferences_d' ),
  $purge_preferences_d  = params_lookup( 'purge_preferences_d' ),
  $force_aptget_update  = params_lookup( 'force_aptget_update' ),
  $my_class             = params_lookup( 'my_class' ),
  $source               = params_lookup( 'source' ),
  $source_dir           = params_lookup( 'source_dir' ),
  $source_dir_purge     = params_lookup( 'source_dir_purge' ),
  $template             = params_lookup( 'template' ),
  $content              = params_lookup( 'content' ),
  $options              = params_lookup( 'options' ),
  $version              = params_lookup( 'version' ),
  $absent               = params_lookup( 'absent' ),
  $audit_only           = params_lookup( 'audit_only' , 'global' ),
  $package              = params_lookup( 'package' ),
  $config_dir           = params_lookup( 'config_dir' ),
  $config_file          = params_lookup( 'config_file' ),
  $sourceslist_file     = params_lookup( 'sourceslist_file' ),
  $sourceslist_template = params_lookup( 'sourceslist_template' ),
  $sourceslist_content  = params_lookup( 'sourceslist_content' ),
  $preferences_file     = params_lookup( 'preferences_file' ),
  $preferences_template = params_lookup( 'preferences_template' ),
  $preferences_content  = params_lookup( 'preferences_content' ),
  $aptconfd_dir         = params_lookup( 'aptconfd_dir' ),
  $sourceslist_dir      = params_lookup( 'sourceslist_dir' ),
  $preferences_dir      = params_lookup( 'preferences_dir' ),
  $config_dir_mode      = params_lookup( 'config_dir_mode' ),
  $config_file_mode     = params_lookup( 'config_file_mode' ),
  $config_file_owner    = params_lookup( 'config_file_owner' ),
  $config_file_group    = params_lookup( 'config_file_group' )
  ) inherits apt::params {

  ### Definition of some variables used in the module
  $array_extra_packages = is_array($apt::extra_packages) ? {
    false     => $apt::extra_packages ? {
      ''      => [],
      default => split($apt::extra_packages, ','),
    },
    default   => $apt::extra_packages,
  }

  # Sanitize of booleans
  $bool_force_aptget_update=any2bool($force_aptget_update)
  $bool_force_conf_d=any2bool($force_conf_d)
  $bool_purge_conf_d=any2bool($purge_conf_d)
  $bool_force_sources_list_d=any2bool($force_sources_list_d)
  $bool_purge_sources_list_d=any2bool($purge_sources_list_d)
  $bool_force_preferences_d=any2bool($force_preferences_d)
  $bool_purge_preferences_d=any2bool($purge_preferences_d)
  $bool_source_dir_purge=any2bool($source_dir_purge)
  $bool_absent=any2bool($absent)
  $bool_audit_only=any2bool($audit_only)

  # Logic management according to parameters provided by users
  $manage_notify = $apt::bool_force_aptget_update ? {
    true  => 'Exec[aptget_update]',
    false => undef,
  }

  $manage_package = $apt::bool_absent ? {
    true  => 'absent',
    false => $apt::version,
  }
  $manage_config_file = $apt::bool_absent ? {
    true      => 'absent',
    default   => $bool_force_conf_d ? {
      true    => 'absent',
      default => 'present',
    }
  }
  $manage_sourceslist_file = $apt::bool_absent ? {
    true      => 'absent',
    default   => $bool_force_sources_list_d ? {
      true    => 'absent',
      default => 'present',
    }
  }
  $manage_preferences_file = $apt::bool_absent ? {
    true      => 'absent',
    default   => $bool_force_preferences_d ? {
      true    => 'absent',
      default => 'present',
    }
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
    ''        => $apt::content ? {
      ''      => undef,
      default => $apt::content,
    },
    default   => template($apt::template),
  }

  $manage_sourceslist_content = $apt::sourceslist_template ? {
    ''        => $apt::sourceslist_content ? {
      ''      => undef,
      default => $apt::sourceslist_content,
    },
    default   => template($apt::sourceslist_template),
  }

  $manage_preferences_content = $apt::preferences_template ? {
    ''        => $apt::preferences_content ? {
      ''      => undef,
      default => $apt::preferences_content,
    },
    default   => template($apt::preferences_template),
  }

  ### Resources managed by the module
  package { $apt::package:
    ensure => $apt::manage_package,
  }

  package { $apt::array_extra_packages:
    ensure => $apt::manage_package,
  }

  if $content or $source or $manage_config_file == 'absent' {
    file { 'apt.conf':
      ensure  => $apt::manage_config_file,
      path    => $apt::config_file,
      mode    => $apt::config_file_mode,
      owner   => $apt::config_file_owner,
      group   => $apt::config_file_group,
      require => Package[$apt::package],
      source  => $apt::manage_file_source,
      content => $apt::manage_file_content,
      notify  => $apt::manage_notify,
      replace => $apt::manage_file_replace,
      audit   => $apt::manage_audit,
    }
  }

  file { 'apt_sources.list':
    ensure  => $apt::manage_sourceslist_file,
    path    => $apt::sourceslist_file,
    mode    => $apt::config_file_mode,
    owner   => $apt::config_file_owner,
    group   => $apt::config_file_group,
    require => Package[$apt::package],
    notify  => $apt::manage_notify,
    content => $manage_sourceslist_content,
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
      notify  => $apt::manage_notify,
      recurse => true,
      purge   => $apt::bool_source_dir_purge,
      force   => $apt::bool_source_dir_purge,
      replace => $apt::manage_file_replace,
      audit   => $apt::manage_audit,
    }
  }

  if $bool_purge_conf_d {
    file { 'apt_conf.dir':
      ensure  => directory,
      path    => $apt::aptconfd_dir,
      mode    => $apt::config_file_mode,
      owner   => $apt::config_file_owner,
      group   => $apt::config_file_group,
      require => Package[$apt::package],
      source  => 'puppet:///modules/apt/empty',
      notify  => $apt::manage_notify,
      ignore  => ['.gitkeep'],
      recurse => true,
      purge   => true,
      force   => true,
      replace => $apt::manage_file_replace,
      audit   => $apt::manage_audit,
    }
  }

  if $bool_purge_sources_list_d {
    file { 'apt_sources_list.dir':
      ensure  => directory,
      path    => $apt::sourceslist_dir,
      mode    => $apt::config_file_mode,
      owner   => $apt::config_file_owner,
      group   => $apt::config_file_group,
      require => Package[$apt::package],
      source  => 'puppet:///modules/apt/empty',
      notify  => $apt::manage_notify,
      ignore  => ['.gitkeep'],
      recurse => true,
      purge   => true,
      force   => true,
      replace => $apt::manage_file_replace,
      audit   => $apt::manage_audit,
    }
  }

  if $manage_preferences_content or $apt::manage_preferences_file == 'absent' {
    file { 'apt_preferences':
      ensure  => $apt::manage_preferences_file,
      path    => $apt::preferences_file,
      mode    => $apt::config_file_mode,
      owner   => $apt::config_file_owner,
      group   => $apt::config_file_group,
      require => Package[$apt::package],
      notify  => $apt::manage_notify,
      content => $manage_preferences_content,
      replace => $apt::manage_file_replace,
      audit   => $apt::manage_audit,
    }
  }

  if $bool_purge_preferences_d {
    file { 'apt_preferences.dir':
      ensure  => directory,
      path    => $apt::preferences_dir,
      mode    => $apt::config_file_mode,
      owner   => $apt::config_file_owner,
      group   => $apt::config_file_group,
      require => Package[$apt::package],
      source  => 'puppet:///modules/apt/empty',
      notify  => $apt::manage_notify,
      ignore  => ['.gitkeep'],
      recurse => true,
      purge   => true,
      force   => true,
      replace => $apt::manage_file_replace,
      audit   => $apt::manage_audit,
    }
  }

  apt::conf { 'update_trigger':
    content => "// File managed by Puppet. Triggers an apt-get update on first run\n",
  }

  include apt::apt_get_update

  if $apt::bool_force_aptget_update {
    Package <| title != $apt::package |> {
      require +> Exec['aptget_update']
    }
  }

  ### Include custom class if $my_class is set
  if $apt::my_class {
    include $apt::my_class
  }

}
