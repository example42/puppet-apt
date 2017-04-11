# = Define: apt::conf
#
# Add an APT configuration file.
#
#
# == Parameters
#
# [*name*]
#   Implicit parameter.
#   Name of the configuration to add
#
# [*source*]
#   Source (via puppet files) of the configuration to add
#
# [*content*]
#   Content (via templates) of the configuration to add
#
# [*priority*]
#   Priority of the configuration to add, defaults to 10
#
# [*ensure*]
#   Whether to add or delete this configuration
#
# [*suffix*]
#   Suffix to be added to files generated.
#
#
# == Examples
#
# Usage:
# apt::conf { 'DisablePdiff':
#   content  => 'Acquire::PDiffs "false";',
#   priority => '99',
# }
#
#
define apt::conf (
  $source               = '' ,
  $content              = '' ,
  $priority             = '10' ,
  $ensure               = present,
  $suffix               = '.conf',
  $notify_aptget_update = true ) {

  $bool_notify_aptget_update=any2bool($notify_aptget_update)

  include apt

  $manage_file_source = $source ? {
    ''        => undef,
    default   => $source,
  }

  $manage_file_content = $content ? {
    ''        => undef,
    default   => $content,
  }
  if $manage_file_content != undef {
    if ! (chomp($content) =~ /;$/ ) {
      $real_manage_file_content = "${content};"
    } else {
      $real_manage_file_content = $content
    }
    validate_re($real_manage_file_content, ';$', "The content attribute does not end with a semicolon. Content: ${content}")
  } else {
    $real_manage_file_content = undef
  }

  $manage_notify = $bool_notify_aptget_update ? {
    true  => 'Exec[apt_update]',
    false => undef,
  }

  file { "apt_conf_${name}":
    ensure  => $ensure,
    path    => "${apt::aptconfd_dir}/${priority}${name}${suffix}",
    mode    => $apt::config_file_mode,
    owner   => $apt::config_file_owner,
    group   => $apt::config_file_group,
    require => Package[$apt::package],
    notify  => $manage_notify,
    source  => $manage_file_source,
    content => $real_manage_file_content,
    audit   => $apt::manage_audit,
  }

}
