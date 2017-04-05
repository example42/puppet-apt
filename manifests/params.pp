# Class: apt::params
#
class apt::params  {

  if $::osfamily != 'Debian' {
    fail('This module only works on Debian or derivatives like Ubuntu')
  }

  # prior to puppet 3.5.0, defined() couldn't test if a variable was defined.
  # strict_variables wasn't added until 3.5.0, so this should be fine.
  if $::puppetversion and versioncmp($::puppetversion, '3.5.0') < 0 {
    $xfacts = {
      'lsbdistcodename'     => $::lsbdistcodename,
      'lsbdistrelease'      => $::lsbdistrelease,
      'lsbdistid'           => $::lsbdistid,
    }
  } else {
    # Strict variables facts lookup compatibility
    $xfacts = {
      'lsbdistcodename' => defined('$lsbdistcodename') ? {
        true    => $::lsbdistcodename,
        default => undef,
      },
      'lsbdistrelease' => defined('$lsbdistrelease') ? {
        true    => $::lsbdistrelease,
        default => undef,
      },
      'lsbdistid' => defined('$lsbdistid') ? {
        true    => $::lsbdistid,
        default => undef,
      },
    }
  }

  $package = 'apt'
  $extra_packages = 'debconf-utils'
  $force_conf_d = false
  $purge_conf_d = false
  $force_sources_list_d = false
  $purge_sources_list_d = false
  $force_preferences_d = false
  $purge_preferences_d = false
  $force_aptget_update = true

  $config_dir = '/etc/apt'
  $config_file = "${apt::params::config_dir}/apt.conf"
  $sourceslist_file = "${apt::params::config_dir}/sources.list"
  $sourceslist_template = ''
  $sourceslist_content = ''
  $preferences_file = "${apt::params::config_dir}/preferences"
  $preferences_template = ''
  $preferences_content = ''
  $aptconfd_dir = "${apt::params::config_dir}/apt.conf.d"
  $sourceslist_dir = "${apt::params::config_dir}/sources.list.d"
  $preferences_dir = "${apt::params::config_dir}/preferences.d"

  $update_command = '/usr/bin/apt-get -qq update'

  $manage_preferences = true
  $manage_sourceslist = true

  $config_dir_mode = '0755'
  $config_file_mode = '0644'
  $config_file_owner = 'root'
  $config_file_group = 'root'

  # General Settings
  $my_class = ''
  $source = ''
  $source_dir = ''
  $source_dir_purge = false
  $template = ''
  $content = ''
  $options = ''
  $version = 'present'
  $absent = false

  ### General module variables that can have a site or per module default
  $audit_only = false
  $keyserver = 'keyserver.ubuntu.com'

  $config_files = {
    'conf'   => {
      'path' => $aptconfd_dir,
      'ext'  => '',
    },
    'pref'   => {
      'path' => $preferences_dir,
      'ext'  => '.pref',
    },
    'list'   => {
      'path' => $sourceslist_dir,
      'ext'  => '.list',
    }
  }

  $source_key_defaults = {
    'server'  => $keyserver,
    'options' => undef,
    'content' => undef,
    'source'  => undef,
  }

  $include_defaults = {
    'deb' => true,
    'src' => false,
  }
}
