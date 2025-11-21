# @summary Main class for setting quadlet support
#
# @param manage_package Should podman package be installed by this module?
# @param package_names What packages are tracked by this module?
# @param package_ensure What state should the packages be in (installed/latests/other?)?
# @param manage_service Should podman.socket service be managed by this module?
# @param socket_enable Should podman.socket be started and enabled?
# @param manage_autoupdate_timer Should podman-auto-update.timer be managed by this module?
# @param autoupdate_timer_ensure Should podman-auto-update.timer be active?
# @param autoupdate_timer_enable Should podman-auto-update.timer be enabled?
# @param autoupdate_timer_name Name of the auto update timer. This is usually podman-auto-update.timer.
# @param create_quadlet_dir Should the directory `/etc/containers/systemd` for storing quadlet files be created. Defaults are in hiera data.
# @param create_quadlet_users_dir
#   Should the directory `/etc/containers/systemd/users` for storing quadlet user files be created. Defaults are in hiera data.
#
# @param selinux_container_manage_cgroup
#   If SELinux is enabled and this is true, set SELinux boolean
#   'container_manage_cgroup' to true. Required if you want to run containers in
#   systemd mode
#   If SELinux is not enabled on system this does nothing.
#
# @param purge_quadlet_dir
#   Should the directory for storing quadlet files be purged. This has no effect
#   unless create_quadlet_dir is set to true.
#
# @param quadlets_hash a `Hash` of quadlets to deploy
#
# @example Set up Podman for quadlets
#   include quadlets
#
# @see https://github.com/containers/podman/blob/main/docs/source/markdown/options/systemd.md container_manage_cgroup
class quadlets (
  Boolean $selinux_container_manage_cgroup = false,
  Boolean $manage_package = true,
  Array[String[1,]] $package_names = ['podman'],
  Stdlib::Ensure::Package $package_ensure = 'installed',
  Boolean $manage_service = true,
  Boolean $socket_enable = true,
  Boolean $manage_autoupdate_timer = false,
  String $autoupdate_timer_ensure = 'running',
  Boolean $autoupdate_timer_enable = true,
  String  $autoupdate_timer_name = 'podman-auto-update.timer',
  Boolean $create_quadlet_dir = false,
  Boolean $create_quadlet_users_dir = false,
  Boolean $purge_quadlet_dir = false,
  Stdlib::CreateResources $quadlets_hash = {},
) {
  $quadlet_dir = '/etc/containers/systemd'
  $quadlet_system_user_dir = '/etc/containers/systemd/users'
  $quadlet_user_dir = '.config/containers/systemd'

  contain quadlets::install
  contain quadlets::config
  contain quadlets::service

  Class['quadlets::install'] -> Class['quadlets::config'] -> Class['quadlets::service']

  $quadlets_hash.each |$_n, $_v| {
    quadlets::quadlet { $_n:
      * => $_v,
    }
  }
}
