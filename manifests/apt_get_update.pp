class apt::apt_get_update (
  $refreshonly = true,
  ) {
  exec { 'aptget_update':
    command     => $apt::update_command,
    logoutput   => false,
    refreshonly => $refreshonly,
  }
}
