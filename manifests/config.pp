# @summary Configure podman for quadlets
# @api private
#
class quadlets::config (
  Boolean $create_quadlet_dir = $quadlets::create_quadlet_dir,
  Boolean $purge_quadlet_dir = $quadlets::purge_quadlet_dir,
) inherits quadlets {
  if $create_quadlet_dir {
    file { $quadlets::quadlet_dir:
      ensure  => directory,
      owner   => root,
      group   => root,
      mode    => '0644',
      purge   => $purge_quadlet_dir,
      force   => $purge_quadlet_dir,
      recurse => $purge_quadlet_dir,
    }
  }
}
