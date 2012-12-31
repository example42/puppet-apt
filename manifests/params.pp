# Class: apt::params
#
class apt::params  {

  $package = 'apt'

  $config_file = '/etc/apt/apt.conf'
  $config_dir = '/etc/apt'

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
  $options = ''
  $version = 'present'
  $absent = false

  ### General module variables that can have a site or per module default
  $audit_only = false

}
