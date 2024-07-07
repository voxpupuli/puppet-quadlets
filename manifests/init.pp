# @summary Main class for setting quadlet support
#
# @param socket_enable Should podman.socket be started and enabled
#
# @example Set up Podman for quadlets
#   include quadlets
#
class quadlets (
  Boolean $socket_enable = true,
) {
  contain quadlets::install
  contain quadlets::service

  Class['quadlets::install'] -> Class['quadlets::service']
}
