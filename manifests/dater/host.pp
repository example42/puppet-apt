class apt::dater::host {
  include apt::dater

  if !defined(Package[$apt::dater::host_package]) {
    package { $apt::dater::host_package:
      ensure => $apt::dater::manage_package,
      noop   => $apt::dater::bool_noops,
    }
  }

  if !$apt::dater::bool_reuse_host_user {
    user { $apt::dater::host_user:
      ensure     => present,
      system     => true,
      home       => $apt::dater::host_home_dir,
      managehome => true;
    }
  }

  if !$apt::dater::bool_reuse_ssh {
    file { "${apt::dater::host_home_dir}/.ssh":
      ensure => directory,
      mode   => 0700,
      owner  => $apt::dater::host_user;
    }

    ssh_authorized_key { "apt-dater-key":
      ensure  => $apt::dater::manage_host_user,
      user    => $apt::dater::host_user,
      options => $apt::dater::ssh_key_options,
      type    => $apt::dater::ssh_key_type,
      key     => $apt::dater::ssh_key,
      require => File["${apt::dater::host_home_dir}/.ssh"];
    }
  }

  sudo::directive { "apt-dater": content => "$apt::dater::host_user ALL=NOPASSWD: /usr/bin/apt-get, /usr/bin/aptitude"; }

  @@apt::dater::host_fragment { $fqdn:
    customer => $apt::dater::customer,
    ssh_user => $apt::dater::host_user,
    ssh_name => $::fqdn,
    ssh_port => 22;
  }
}