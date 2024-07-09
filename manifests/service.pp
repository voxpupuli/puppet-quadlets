# @summary Manage the podman socket
# @api private
#
class quadlets::service (
  $socket_enable = $quadlets::socket_enable,
) {
  service { 'podman.socket':
    ensure => $socket_enable,
    enable => $socket_enable,
  }
}
