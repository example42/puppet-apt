# Class: apt::params
#
class apt::params  {

  $package = 'apt'
  $extra_packages = 'debconf-utils'
  $force_conf_d = false
  $force_sources_list_d = false
  $force_aptget_update = false

  $config_dir = '/etc/apt'
  $config_file = "${apt::params::config_dir}/apt.conf"
  $sourceslist_file = "${apt::params::config_dir}/sources.list"
  $sourceslist_template = ''
  $sourceslist_content = ''
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

}
