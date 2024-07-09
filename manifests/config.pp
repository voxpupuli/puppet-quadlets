# @summary Configure podman for quadlets
# @api private
#
class quadlets::config (
  $create_quadlet_dir = $quadlets::create_quadlet_dir,
) {
  if $create_quadlet_dir {
    file { '/etc/containers/systemd':
      ensure => directory,
      owner  => root,
      group  => root,
      mode   => '0644',
    }
  }
}
