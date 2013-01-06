# =Define: apt::sources_list
#
# This define places directly a custom file in sources.list.d
#
# This is an alternative way to apt::repository to manage repository
#
#
# == Parameters
#
# [*name*]
#   Implicit parameter.
#   Name of the repository to add
#
# [*source*]
#   Source to copy for this repository configuration
#
# [*content*]
#   Content (from a template) to use for this repository configuration
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
#    source     => false
#  }
define apt::sources_list (
  $source  = '' ,
  $content = '' ,
  $ensure  = present ) {

  include apt
  $manage_file_source = $source ? {
    ''        => undef,
    default   => $source,
  }

  $manage_file_content = $content ? {
    ''        => undef,
    default   => $content,
  }

  file { "apt_sourceslist_${name}":
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

}
