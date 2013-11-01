# = Class: apt::dater::manager
#
class apt::dater::manager {
  include apt::dater

  if !defined(Package[$apt::dater::package]) {
    package { $apt::dater::package:
      ensure => $apt::dater::manage_package,
      noop   => $apt::dater::noops,
    }
  }

  if !$apt::dater::bool_reuse_ssh {
    if !defined(File[$apt::dater::manager_ssh_dir]) {
      file { $apt::dater::manager_ssh_dir:
        ensure => $apt::dater::manage_directory,
        mode   => '0700',
        owner  => $apt::dater::manager_user;
      }
    }

    file { $apt::dater::manager_ssh_private_file:
      ensure  => $apt::dater::manage_file,
      content => $apt::dater::manager_ssh_key,
      mode    => '0600',
      owner   => $apt::dater::manager_user;
    }

  }

  file {
    $apt::dater::manager_conf_dir:
      ensure  => $apt::dater::manage_directory,
      mode    => '0700',
      owner   => $apt::dater::manager_user;

    $apt::dater::manager_ad_conf_dir:
      ensure  => $apt::dater::manage_directory,
      mode    => '0700',
      owner   => $apt::dater::manager_user,
      require => File[$apt::dater::manager_conf_dir];

    "${apt::dater::manager_ad_conf_dir}/apt-dater.conf":
      ensure  => $apt::dater::manage_file,
      content => template('apt/apt-dater.conf.erb'),
      mode    => '0600',
      owner   => $apt::dater::manager_user,
      require => File[$apt::dater::manager_ad_conf_dir];

    "${apt::dater::manager_ad_conf_dir}/hosts.conf":
      ensure => $apt::dater::manage_file,
      source => "${apt::dater::manager_ad_conf_dir}/hosts.conf.generated",
      mode   => '0600',
      owner  => $apt::dater::manager_user,
      require => File[$apt::dater::manager_ad_conf_dir];

    "${apt::dater::manager_ad_conf_dir}/screenrc":
      ensure  => $apt::dater::manage_file,
      content => template('apt/apt-dater-screenrc.erb'),
      mode    => '0600',
      owner   => $apt::dater::manager_user,
      require => File[$apt::dater::manager_ad_conf_dir];

    '/usr/local/bin/update-apt-dater-hosts':
      ensure  => $apt::dater::manage_file,
      content => template('apt/update-apt-dater-hosts.erb'),
      mode    => '0755',
      owner   => root,
      group   => root,
      notify  => Exec['update-hosts.conf'];

    $apt::dater::manager_fragments_dir:
      ensure  => $apt::dater::manage_directory,
      source  => 'puppet:///modules/apt/empty',
      mode    => '0700',
      owner   => $apt::dater::manager_user,
      recurse => true,
      ignore  => ['.gitkeep'],
      purge   => true,
      force   => true;
  }

  exec { 'update-hosts.conf':
    command => "/usr/local/bin/update-apt-dater-hosts > ${apt::dater::manager_ad_conf_dir}/hosts.conf.generated",
    unless  => "bash -c 'cmp ${apt::dater::manager_ad_conf_dir}/hosts.conf.generated <(/usr/local/bin/update-apt-dater-hosts)'",
    path    => '/bin:/usr/bin:/sbin:/usr/sbin',
    require => File[$apt::dater::manager_ad_conf_dir],
  }

  # explicitly define the update order, uses a generated file to get proper diff support from File
  Apt::Dater::Host_fragment <<| |>> ~> Exec['update-hosts.conf'] -> File["${apt::dater::manager_ad_conf_dir}/hosts.conf"]
}
