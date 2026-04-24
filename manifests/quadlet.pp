# @summary Generate and manage podman quadlet definitions (podman > 4.4.0)
#
# @see podman-systemd.unit.5 https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html
#
# @param quadlet of the quadlet file this is the namevar.
# @param ensure State of the container definition.
# @param validate_quadlet Validate quadlet with `podman-system-generator --dryrun`
# @param mode Filemode of container file.
# @param active Make sure the container is running.
# @param user Specify which user to run as. If `undef` the quadlet will run rootful.
# @param group Specify which group should own the quadlets. If it is `undef` the `$user` parameter will be used.
# @param homedir Specify home directory. If it `undef` then `/home/$user` will be used.
# @param location Specifies the location to create the quadlet in. If `home` then `$home/.config/containers/systemd` will be used. If `system` then `/etc/containers/systemd/users/$user` will be used.
# @param unit_entry The `[Unit]` section definition.
# @param install_entry The `[Install]` section definition.
# @param service_entry The `[Service]` section definition.
# @param container_entry The `[Container]` section defintion.
# @param pod_entry The `[Pod]` section defintion.
# @param volume_entry The `[Volume]` section defintion.
# @param network_entry The `[Network]` section defintion.
# @param kube_entry The `[Kube]` section defintion.
# @param image_entry The `[Image]` section defintion.
# @param build_entry The `[Build]` section defintion.
#
# @example Run a CentOS Container
#   quadlets::quadlet{ 'centos.container':
#     ensure          => present,
#     unit_entry      => {
#       'Description' => 'Trivial Container that will be very lazy',
#     },
#     service_entry   => {
#       'TimeoutStartSec' => '900',
#     },
#     container_entry => {
#       'Image' => 'quay.io/centos/centos:latest',
#       'Exec'  => 'sh -c "sleep inf"',
#     },
#     install_entry   => {
#       'WantedBy' => 'default.target'
#     },
#     active          => true,
#   }
#
# @example Run a Pod using a kubernetes Yaml definition
#   quadlets::quadlet{ 'centos.container':
#     ensure        => present,
#     unit_entry => {
#      'Description' => 'Pod running my application',
#     },
#     kube_entry    => {
#      'Yaml' => '/path/to/yaml/file.yaml',
#     },
#     install_entry => {
#       'WantedBy' => 'default.target'
#     },
#     active        => true,
#   }
#
# @example Run a CentOS user Container specifying home dir
#   quadlets::quadlet{ 'centos.container':
#     ensure          => present,
#     user            => 'containers',
#     homedir         => '/nfs/home/containers',
#     unit_entry      => {
#       'Description' => 'Trivial Container that will be very lazy',
#     },
#     service_entry   => {
#       'TimeoutStartSec' => '900',
#     },
#     container_entry => {
#      'Image' => 'quay.io/centos/centos:latest',
#      'Exec'  => 'sh -c "sleep inf"'
#     },
#     install_entry   => {
#       'WantedBy' => 'default.target',
#     },
#     active          => true,
#   }
#
# @example Run a CentOS user Container from System User Directory
#   quadlets::quadlet{ 'centos.container':
#     ensure          => present,
#     user            => 'containers',
#     location        => 'system',
#     unit_entry      => {
#       'Description' => 'Trivial Container that will be very lazy',
#     },
#     service_entry   => {
#       'TimeoutStartSec' => '900',
#     },
#     container_entry => {
#      'Image' => 'quay.io/centos/centos:latest',
#      'Exec'  => 'sh -c "sleep inf"'
#     },
#     install_entry   => {
#       'WantedBy' => 'default.target',
#     },
#     active          => true,
#   }
#
# @example Build a local container image and run it
#   quadlets::quadlet{ 'myapp.build':
#     ensure      => present,
#     build_entry => {
#       'ImageTag'            => 'localhost/myapp:latest',
#       'SetWorkingDirectory' => 'unit',
#     },
#   }
#   quadlets::quadlet{ 'myapp.container':
#     ensure          => present,
#     container_entry => {
#       'Image' => 'myapp.build',
#       'Exec'  => '/usr/bin/myapp',
#     },
#     install_entry   => {
#       'WantedBy' => 'default.target',
#     },
#   }
#
# @example Run a CentOS user Container without managing the aspects of the user
#   quadlets::quadlet{'centos.container':
#     ensure          => present,
#     user            => 'containers',
#     unit_entry      => {
#       'Description' => 'Trivial Container that will be very lazy',
#     },
#     service_entry   => {
#       'TimeoutStartSec' => '900',
#     },
#     container_entry => {
#       'Image' => 'quay.io/centos/centos:latest',
#       'Exec'  => 'sh -c "sleep inf"'
#     },
#     install_entry   => {
#       'WantedBy' => 'default.target'
#     },
#     active          => true,
#   }
#
define quadlets::quadlet (
  Enum['present', 'absent'] $ensure = 'present',
  Quadlets::Quadlet_name $quadlet = $title,
  Boolean $validate_quadlet = true,
  Stdlib::Filemode $mode = '0444',
  Optional[Boolean] $active = undef,
  Optional[String[1]] $user = undef,
  Optional[String[1]] $group = undef,
  Optional[Stdlib::Unixpath] $homedir = undef,
  Enum['system','home'] $location = 'home',
  Optional[Systemd::Unit::Install] $install_entry = undef,
  Optional[Quadlets::Unit::Unit] $unit_entry = undef,
  Optional[Systemd::Unit::Service] $service_entry = undef,
  Optional[Quadlets::Unit::Container] $container_entry = undef,
  Optional[Quadlets::Unit::Volume] $volume_entry = undef,
  Optional[Quadlets::Unit::Network] $network_entry = undef,
  Optional[Quadlets::Unit::Pod] $pod_entry = undef,
  Optional[Quadlets::Unit::Kube] $kube_entry = undef,
  Optional[Quadlets::Unit::Image] $image_entry = undef,
  Optional[Quadlets::Unit::Build] $build_entry = undef,
) {
  $_split = $quadlet.split('[.]')
  $_name = $_split[0]
  $_type = $_split[1]

  # Map each quadlet type to its one permitted section entry variable.
  # Every other entry variable must be undef for that type.
  $_type_entry_map = {
    'container' => 'container_entry',
    'volume'    => 'volume_entry',
    'network'   => 'network_entry',
    'pod'       => 'pod_entry',
    'kube'      => 'kube_entry',
    'image'     => 'image_entry',
    'build'     => 'build_entry',
  }

  $_all_entries = ['container_entry', 'volume_entry', 'network_entry',
  'pod_entry', 'kube_entry', 'image_entry', 'build_entry']

  $_allowed_entry = $_type_entry_map[$_type]

  if $_allowed_entry == undef {
    fail("Should never be here due to typing on quadlet (unknown type: ${_type})")
  }

  $_invalid_entries = $_all_entries.filter |$e| { $e != $_allowed_entry and getvar($e) != undef }

  unless $_invalid_entries.empty {
    fail("Only ${_allowed_entry} makes sense on a ${_type} quadlet; unexpected: ${_invalid_entries.join(', ')}")
  }

  $_service = $_type in ['container', 'kube'] ? {
    true    => "${_name}.service",
    default => "${_name}-${_type}.service",
  }

  include quadlets

  if $user { # rootless container
    if $location == 'system' {
      $_quadlet_dir = "${quadlets::quadlet_system_user_dir}/${user}"
      $_file_user = 'root'
      $_file_group = 'root'
    } else { # home
      $_file_user = $user
      $_file_group = pick($group, $user)
      $_user_homedir = pick($homedir, "/home/${user}")
      $_quadlet_dir = "${_user_homedir}/${quadlets::quadlet_user_dir}"
    }
  } else { # rootfull container
    $_quadlet_dir = $quadlets::quadlet_dir
    $_file_user = 'root'
    $_file_group = 'root'
  }
  $_quadlet_file = "${_quadlet_dir}/${quadlet}"

  # We can only validate a directory of quadlet files and the file extension of the new quadlet
  # must be correct so we cannot test % directly :-(
  #
  # Create a new tmp directory and copy the new quadlet to validate it.
  $_validate_cmd = $validate_quadlet ? {
    true    => epp('quadlets/validate_cmd.epp', {
      'quadlet' => $quadlet,
      'is_user' => $user ? {
        undef   => false,
        default => true
      },
      'dest' => $_quadlet_dir,
    }),
    default => undef,
  }

  file { $_quadlet_file:
    ensure       => $ensure,
    owner        => $_file_user,
    group        => $_file_group,
    mode         => $mode,
    validate_cmd => $_validate_cmd,
    content      => epp('quadlets/quadlet_file.epp', {
      'unit_entry'      => $unit_entry,
      'service_entry'   => $service_entry,
      'install_entry'   => $install_entry,
      'container_entry' => $container_entry,
      'volume_entry'    => $volume_entry,
      'network_entry'   => $network_entry,
      'pod_entry'       => $pod_entry,
      'kube_entry'      => $kube_entry,
      'image_entry'     => $image_entry,
      'build_entry'     => $build_entry,
    }),
  }

  ensure_resource('systemd::daemon_reload', $quadlet, { 'user' => $user })
  File[$_quadlet_file] ~> Systemd::Daemon_reload[$quadlet]

  if $active != undef {
    if $user {
      systemd::user_service { $_service:
        ensure => $active,
        enable => $active,
        user   => $user,
      }

      if $ensure == 'absent' {
        Systemd::User_service[$_service] -> File[$_quadlet_file]
        File[$_quadlet_file] ~> Systemd::Daemon_reload[$quadlet]
      } else {
        File[$_quadlet_file] ~> Systemd::User_service[$_service]
        Systemd::Daemon_reload[$quadlet] -> Systemd::User_service[$_service]
      }
    } else {
      service { $_service:
        ensure => $active,
      }

      if $ensure == 'absent' {
        Service[$_service] -> File[$_quadlet_file]
        File[$_quadlet_file] ~> Systemd::Daemon_reload[$quadlet]
      } else {
        File[$_quadlet_file] ~> Service[$_service]
        Systemd::Daemon_reload[$quadlet] -> Service[$_service]
      }
    }
  }
}
