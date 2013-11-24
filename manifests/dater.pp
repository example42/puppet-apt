# = Class: apt::dater
#
# This is the main apt::dater class to configure a node for being managed by apt-dater.
#
#
# == Parameters
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*my_class*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, apt::dater class will automatically "include $my_class"
#   Can be defined also by the (top scope) variable $apt_dater_myclass
#
# [*version*]
#   The package version, used in the ensure parameter of package type.
#   Default: present. Can be 'latest' or a specific version number.
#   Note that if the argument absent (see below) is set to true, the
#   package is removed, whatever the value of version parameter.
#
# [*absent*]
#   Set to 'true' to remove package(s) installed by module
#   Can be defined also by the (top scope) variable $apt_dater_absent
#
# [*noops*]
#   Set noop metaparameter to true for all the resources managed by the module.
#   Basically you can run a dryrun for this specific module if you set
#   this to true. Default: undef
#
# [*debug*]
#   Set to 'true' to enable modules debugging
#   Can be defined also by the (top scope) variables $apt_dater_debug and $debug
#
# Default class params - As defined in apt::dater::params.
# Note that these variables are mostly defined and used in the module itself,
# overriding the default values might not affected all the involved components.
# Set and override them only if you know what you're doing.
# Note also that you can't override/set them via top scope variables.
#
# [*role*]
#   One of 'host', 'manager' or 'all'.
#
# [*customer*]
#   A grouping to be displayed in the apt-dater interface. Should be a simple alphanumeric string.
#
# [*package*]
#   The name of apt-dater package
#
# [*host_package*]
#   The name of apt-dater-host package
#
# [*user*]
#   Which user to use when connecting to the hosts. By default the user is called
#   "apt-dater" and created for you.
#
# [*home_dir*]
#   Where to put the config and ssh keys for the apt::dater::user.
#
# [*reuse_user*]
#   If your user is managed elsewhere, set this to true. Then this class doesn't touch
#   the user.
#
# [*reuse_ssh*]
#   If your ssh connection is managed elsewhere, set this to true. Then this class
#   doesn't touch the ssh keys.
#
# [*ssh_key_options*]
#   The options for the ssh key, as required by ssh_authorized_key.
#
# [*ssh_key_type*]
#   The type for the ssh key, as required by ssh_authorized_key.
#
# [*ssh_key*]
#   The ssh key, as required by ssh_authorized_key.
#
# [*manager_user*]
#   The user managing apt-dater. Only used on hosts with the 'manager' role.
#
# [*manager_ssh_dir*]
#   Where to put the secret apt-dater identity. Only used on hosts with the 'manager' role.
#
# [*manager_ssh_key*]
#   The secret apt-dater identity. Only used on hosts with the 'manager' role.
#
# == Examples
#
# You can use this class in 2 ways:
# - Set variables (at top scope level on in a ENC) and "include apt::dater"
# - Call apt::dater as a parametrized class
#
# See README for details.
#
class apt::dater (
  $my_class         = params_lookup('my_class'),
  $version          = params_lookup('version'),
  $absent           = params_lookup('absent'),
  $noops            = params_lookup('noops'),
  $debug            = params_lookup('debug', 'global'),
  $role             = params_lookup('role'),
  $customer         = params_lookup('customer'),
  $package          = params_lookup('package'),
  $host_package     = params_lookup('host_package'),
  $host_update_cmd  = params_lookup('host_update_cmd'),
  $host_user        = params_lookup('host_user'),
  $host_home_dir    = params_lookup('host_home_dir'),
  $reuse_host_user  = params_lookup('reuse_host_user'),
  $reuse_ssh        = params_lookup('reuse_ssh'),
  $ssh_key_options  = params_lookup('ssh_key_options'),
  $ssh_key_type     = params_lookup('ssh_key_type'),
  $ssh_key          = params_lookup('ssh_key'),
  $ssh_port         = params_lookup('ssh_port'),
  $manager_user     = params_lookup('manager_user'),
  $manager_home_dir = params_lookup('manager_home_dir'),
  $manager_ssh_key  = params_lookup('manager_ssh_key')
  ) inherits apt::dater::params {

  $bool_absent = any2bool($apt::dater::absent)
  $bool_debug = any2bool($apt::dater::debug)
  $bool_reuse_host_user = any2bool($apt::dater::reuse_host_user)
  $bool_reuse_ssh = any2bool($apt::dater::reuse_ssh)

  # Definition of some variables used in the module
  $manage_package = $apt::dater::bool_absent ? {
    true  => 'absent',
    false => $version,
  }

  $manage_file = $apt::dater::bool_absent ? {
    true  => 'absent',
    false => 'present',
  }

  $manage_directory = $apt::dater::bool_absent ? {
    true  => 'absent',
    false => 'directory',
  }

  $manage_host_user = $apt::dater::bool_absent ? {
    true  => 'absent',
    false => 'present',
  }

  $manager_ssh_dir = "${apt::dater::manager_home_dir}/.ssh"
  $manager_ssh_private_file = "${apt::dater::manager_ssh_dir}/id_apt_dater"
  $manager_conf_dir = "${apt::dater::manager_home_dir}/.config"
  $manager_ad_conf_dir = "${apt::dater::manager_conf_dir}/apt-dater"
  $manager_ad_hosts_file = "${apt::dater::manager_ad_conf_dir}/hosts.conf"
  $manager_fragments_dir = "${settings::vardir}/apt-dater-fragments"

  # Managed resources
  if $apt::dater::role == 'host' or $apt::dater::role == 'all' {
    include apt::dater::host
  }

  if $apt::dater::role == 'manager' or $apt::dater::role == 'all' {
    include apt::dater::manager
  }

  # Include custom class if $my_class is set
  if $apt::dater::my_class {
    include $apt::dater::my_class
  }

  # Debugging, if enabled ( debug => true )
  if $apt::dater::bool_debug == true {
    file { 'debug_apt::dater':
      ensure  => $apt::dater::manage_package,
      path    => "${settings::vardir}/debug-apt-dater",
      mode    => '0640',
      owner   => 'root',
      group   => 'root',
      content => inline_template('<%= scope.to_hash.reject { |k,v| k.to_s =~ /(uptime.*|path|timestamp|free|.*password.*|.*psk.*|.*key)/ }.to_yaml %>'
      ),
      noop    => $apt::dater::noops,
    }
  }
}
