class apt::apt_get_update (
  $refreshonly = true,
  ) {
  exec { 'apt_update':
    command     => $apt::update_command,
    logoutput   => 'on_failure',
    refreshonly => $refreshonly,
  }
}
