# @summary Manage the podman socket service
# @api private
#
class quadlets::service (
  Boolean $manage_service = $quadlets::manage_service,
  Boolean $socket_enable = $quadlets::socket_enable,
) {
  if $manage_service {
    service { 'podman.socket':
      ensure => $socket_enable,
      enable => $socket_enable,
    }
  }
}
