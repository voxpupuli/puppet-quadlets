# @summary Main class for setting quadlet support
#
# @param socket_enable Should podman.socket be started and enabled
# @param create_quadlet_dir Should the directory for storing quadlet files be created.
#
# @param purge_quadlet_dir
#   Should the directory for storing quadlet files be purged. This has no effect
#   unless create_quadlet_dir is set to true.
#
# @example Set up Podman for quadlets
#   include quadlets
#
class quadlets (
  Boolean $socket_enable = true,
  Boolean $create_quadlet_dir = false,
  Boolean $purge_quadlet_dir = false,
) {
  $quadlet_dir = '/etc/containers/systemd'

  contain quadlets::install
  contain quadlets::config
  contain quadlets::service

  Class['quadlets::install'] -> Class['quadlets::config'] -> Class['quadlets::service']
}
