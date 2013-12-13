# Define apt::ppa
# Derived from https://github.com/puppetlabs/puppetlabs-apt/blob/master/manifests/ppa.pp
#
define apt::ppa(
  $release          = $::lsbdistcodename,
  $options          = '-y',
  $exec_environment = undef
) {
  include apt

  $sources_list_d = $apt::sourceslist_dir

  if ! $release {
    fail('lsbdistcodename fact not available: release parameter required')
  }

  $filename_without_slashes = regsubst($name, '/', '-', 'G')
  $filename_without_dots    = regsubst($filename_without_slashes, '\.', '_', 'G')
  $filename_without_ppa     = regsubst($filename_without_dots, '^ppa:', '', 'G')
  $sources_list_d_filename  = "${filename_without_ppa}-${release}.list"

  $package = $::lsbdistrelease ? {
    /^[1-9]\..*|1[01]\..*|12.04$/ => 'python-software-properties',
    default                       => 'software-properties-common',
  }

  if ! defined(Package[$package]) {
    package { $package:
      before => Exec["add-apt-repository-${name}"],
    }
  }

  exec { "add-apt-repository-${name}":
    environment  => $exec_environment,
    command      => "/usr/bin/add-apt-repository ${options} ${name} && apt-get update",
    unless       => "/usr/bin/test -s ${sources_list_d}/${sources_list_d_filename}",
    logoutput    => 'on_failure',
  }

}
