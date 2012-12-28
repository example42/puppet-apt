# Define: apt::repository
#
# Add repository to /etc/apt/sources.list.d
#
# Usage:
#  apt::repository { "name":
#    url        => 'repository url',
#    distro     => 'distrib name',
#    repository => 'repository name(s)'
#    source     => false
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
  $key      = '',
  $key_url  = '',
  $template = 'apt/repository.list.erb',
  $source   = false,
  $ensure   = 'present'
  ) {
  require apt

  file { "repository_${name}":
    ensure  => $ensure,
    path    => "${apt::sourcelist_dir}/${name}.list",
    mode    => $apt::config_file_mode,
    owner   => $apt::config_file_owner,
    group   => $apt::config_file_group,
    require => Package['apt'],
    before  => Exec['aptget_update'],
    notify  => Exec['aptget_update'],
    source  => $manage_file_source,
    content => template($template),
    audit   => $apt::manage_audit,
  }

  if $key {
    case $key_url {
      '' : {
        exec { "aptkey_add_${key}":
          command => "gpg --recv-key ${key} ; gpg -a --export | apt-key add -",
          unless  => "apt-key list | grep -q ${key}",
        }
      }
      default: {
        exec { "aptkey_add_${key}":
          command => "wget -O - ${key_url} | apt-key add -",
          unless  => "apt-key list | grep -q ${key}",
        }
      }
    }
  }
}
