# Class: apt::params
#
class apt::params  {

  $package = 'debconf-utils'

  $config_file = '/etc/apt/apt.conf'
  $config_dir = '/etc/apt'

  $update_command = '/usr/bin/apt-get -qq update'
  
  $manage_preferences = true
  $manage_sourceslist = true
  
  $config_dir_mode = '0755'
  $config_file_mode = '0644'
  $config_file_owner = 'root'
  $config_file_group = 'root'

  $my_class = ''
  $source = ''
  $source_dir = ''
  $source_dir_purge = false
  $template = ''
  $options = ''
  $absent = false
  $audit_only = false
}
