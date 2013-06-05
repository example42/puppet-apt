# Class: apt::dater::params
#
# This class defines default parameters used by the main module class apt::dater
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to apt::dater class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class apt::dater::params {
  # Application related parameters
  $role = 'host'
  $customer = 'Hosts'
  $package = $::operatingsystem ? {
    default => 'apt-dater',
  }
  $host_package = $::operatingsystem ? {
    default => 'apt-dater-host',
  }
  $host_user = 'apt-dater'
  $host_home_dir = $::operatingsystem ? {
    default => '/var/lib/apt-dater',
  }
  $reuse_host_user = false
  $reuse_ssh = false
  $ssh_key_options = []
  $ssh_key_type = ''
  $ssh_key = ''

  $manager_user = 'root'
  $manager_home_dir = $::operatingsystem ? {
    default => '/root',
  }
  $manager_ssh_key = ''

  # General Settings
  $my_class = ''
  $version = 'present'
  $absent = false
  $noops = false
}