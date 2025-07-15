# @summary Manage the podman socket and update service
# @api private
#
class quadlets::service (
  Boolean $manage_service = $quadlets::manage_service,
  Boolean $socket_enable = $quadlets::socket_enable,
  Boolean $manage_autoupdate_timer = $quadlets::manage_autoupdate_timer,
  Boolean $autoupdate_timer_enable = $quadlets::autoupdate_timer_enable,
  String  $autoupdate_timer_name = $quadlets::autoupdate_timer_name,
) {
  if $manage_service {
    service { 'podman.socket':
      ensure => $socket_enable,
      enable => $socket_enable,
    }
  }

  if $manage_autoupdate_timer {
    service { $autoupdate_timer_name:
      enable => $autoupdate_timer_enable,
    }
  }
}
