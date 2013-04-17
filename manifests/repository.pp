# =Define: apt::repository
#
# Add repository to /etc/apt/sources.list.d
#
#
# == Parameters
#
# [*name*]
#   Implicit parameter.
#   Name of the repository to add
#
# [*url*]
#   Url of the repository to add
#
# [*distro*]
#   Name of the distribution to use
#
# [*repository*]
#   Name of the sections (ie main, contrib, non-free, ...) to use
#
# [*src_repo*]
#   Is this repository a source one (ie deb-src instead of deb)
#
# [*key*]
#   Fingerprint of the key to retrieve
#
# [*key_url*]
#   Url from which fetch the key
#
# [*template*]
#   Custom template to use to fill the repository configuration (instead of the default one)
#
# [*source*]
#   Source to copy for this repository configuration
#
# [*keyring_package*]
#   Optional name of the keyring package for the repo
#
# [*environment*]
#   Environment to pass to the executed commands
#
# [*path*]
#   Path to pass to the executed commands
#
# [*ensure*]
#   Whether to add or delete this repository
#
#
# == Examples
#
# Usage:
#  apt::repository { "name":
#    url        => 'repository url',
#    distro     => 'distrib name',
#    repository => 'repository name(s)'
#  }
#
# For example, to add the standard Ubuntu Lucid repository, you can use
#
#   apt::repository { "ubuntu":
#    url        => "http://it.archive.ubuntu.com/ubuntu/",
#    distro     => 'lucid',
#    repository => 'main restricted',
#   }
# This will make the file /etc/apt/sources.list.d/ubuntu.list
# with content:
#
#   deb http://it.archive.ubuntu.com/ubuntu/ lucid main restricted
#
# If you have specified the source => true (the default is false), the line
# was:
#
#   deb-src http://it.archive.ubuntu.com/ubuntu/ lucid main restricted
#
define apt::repository (
  $url,
  $distro,
  $repository,
  $src_repo    = false,
  $key         = '',
  $key_url     = '',
  $template    = '',
  $source      = '',
  $environment = undef,
  $keyring_package = '',
  $path        = '/usr/sbin:/usr/bin:/sbin:/bin',
  $ensure      = 'present'
  ) {
  include apt

  $manage_file_source = $source ? {
    ''        => undef,
    default   => $source,
  }

  $manage_file_content = $source ? {
    ''        => $template ? {
      ''      => template('apt/repository.list.erb'),
      default => template($template),
    },
    default   => undef,
  }

  file { "apt_repository_${name}":
    ensure  => $ensure,
    path    => "${apt::sourceslist_dir}/${name}.list",
    mode    => $apt::config_file_mode,
    owner   => $apt::config_file_owner,
    group   => $apt::config_file_group,
    require => Package[$apt::package],
    before  => Exec['aptget_update'],
    notify  => Exec['aptget_update'],
    source  => $manage_file_source,
    content => $manage_file_content,
    audit   => $apt::manage_audit,
  }

  if $key and ! defined(Apt::Key[$key]) {
    apt::key { $key:
      url         => $key_url,
      environment => $environment,
      path        => $path,
      fingerprint => $key,
      notify      => Exec['aptget_update'],
      before      => Exec['aptget_update'],
    }
  }

  if $keyring_package != '' {
    if !defined(Package[$keyring_package]) {
      package { $keyring_package:
        ensure  => present,
        require => [ Exec['aptget_update'] , File["apt_repository_${name}"] ],
      }
    }
  }

}
