class apt::dater::manager {
  include apt::dater

  if !defined(Package[$apt::dater::package]) {
    package { $apt::dater::package:
      ensure => $apt::dater::manage_package,
      noop   => $apt::dater::bool_noops,
    }
  }

  if !$apt::dater::bool_reuse_ssh {
    if !defined(File[$apt::dater::manager_ssh_dir]) {
      file { $apt::dater::manager_ssh_dir:
        ensure => $apt::dater::manage_directory,
        mode   => 0700,
        owner  => $apt::dater::manager_user;
      }
    }

    file { $apt::dater::manager_ssh_private_file:
      ensure  => $apt::dater::manage_file,
      content => $apt::dater::manager_ssh_key,
      mode    => 0600,
      owner   => $apt::dater::manager_user;
    }

  }

  file {
    $apt::dater::manager_ad_conf_dir:
      ensure => $apt::dater::manage_directory,
      mode   => 0700,
      owner  => $apt::dater::manager_user;

    "${apt::dater::manager_ad_conf_dir}/apt-dater.conf":
      ensure  => $apt::dater::manage_file,
      content => template("apt/apt-dater.conf.erb"),
      mode    => 0600,
      owner   => $apt::dater::manager_user;

    "/usr/local/bin/update-apt-dater-hosts":
      ensure  => $apt::dater::manage_file,
      content => template("apt/update-apt-dater-hosts.erb"),
      mode    => 0755,
      owner   => root,
      group   => root,
      notify  => Exec["update-hosts.conf"];

    $apt::dater::manager_fragments_dir:
      ensure  => $apt::dater::manage_directory,
      source  => 'puppet:///modules/apt/empty',
      mode    => 0700,
      owner   => $apt::dater::manager_user,
      recurse => true,
      ignore  => ['.gitkeep'],
      purge   => true,
      force   => true;
  }

  Apt::Dater::Host_fragment <<| |>> ~> exec { "update-hosts.conf":
    command     => "/usr/local/bin/update-apt-dater-hosts > ${apt::dater::manager_ad_conf_dir}/hosts.conf",
    refreshonly => true;
  }
}