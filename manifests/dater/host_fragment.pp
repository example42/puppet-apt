# This define is used to export/collect the required connection information from hosts to managers.
define apt::dater::host_fragment ($customer, $ssh_user, $ssh_name, $ssh_port) {
  include apt::dater

  file { "${apt::dater::manager_fragments_dir}/${customer}:${ssh_user}@${ssh_name}:${ssh_port}":
    ensure  => present,
    content => '';
  }
}