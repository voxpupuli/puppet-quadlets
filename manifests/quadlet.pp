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
# @param unit_entry The `[Unit]` section definition.
# @param install_entry The `[Install]` section definition.
# @param service_entry The `[Service]` section definition.
# @param container_entry The `[Container]` section defintion.
# @param pod_entry The `[Pod]` section defintion.
# @param volume_entry The `[Volume]` section defintion.
# @param network_entry The `[Network]` section defintion.
# @param kube_entry The `[Kube]` section defintion.
# @param image_entry The `[Image]` section defintion.
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
  Optional[Systemd::Unit::Install] $install_entry = undef,
  Optional[Quadlets::Unit::Unit] $unit_entry = undef,
  Optional[Systemd::Unit::Service] $service_entry = undef,
  Optional[Quadlets::Unit::Container] $container_entry = undef,
  Optional[Quadlets::Unit::Volume] $volume_entry = undef,
  Optional[Quadlets::Unit::Network] $network_entry = undef,
  Optional[Quadlets::Unit::Pod] $pod_entry = undef,
  Optional[Quadlets::Unit::Kube] $kube_entry = undef,
  Optional[Quadlets::Unit::Image] $image_entry = undef,
) {
  $_split = $quadlet.split('[.]')
  $_name = $_split[0]
  $_type = $_split[1]

  # Validate the input
  case $_type {
    'container': {
      if $volume_entry or $pod_entry or $image_entry or $network_entry {
        fail('A volume_entry, pod_entry, image_entry or network_entry makes no sense on a container quadlet')
      }
    }
    'volume': {
      if $container_entry or $pod_entry or $kube_entry or $image_entry or $network_entry {
        fail('A container_entry, pod_entry, kube_entry, network_entry or image_entry makes no sense on a volume quadlet')
      }
    }
    'network': {
      if $container_entry or $pod_entry or $kube_entry or $image_entry or $volume_entry {
        fail('A container_entry, pod_entry, volume_entry, image_entry or kube_entry makes no sense on a network quadlet')
      }
    }
    'pod': {
      if $container_entry or $volume_entry or $kube_entry or $image_entry or $network_entry {
        fail('A container_entry, volume_entry, kube_entry, network_entry or image_entry makes no sense on a pod quadlet')
      }
    }
    'kube': {
      if $volume_entry or $pod_entry or $container_entry or $image_entry or $network_entry {
        fail('A container_entry, pod_entry, volume_entry, network_entry or image_entry makes no sense on a kube quadlet')
      }
    }
    'image': {
      if $volume_entry or $pod_entry or $container_entry or $kube_entry or $network_entry {
        fail('A container_entry, pod_entry, volume_entry, network_entry or kube_entry makes no sense on an image quadlet')
      }
    }
    default: {
      fail('Should never be here due to typing on quadlet')
    }
  }

  $_service = $_type in ['container','kube'] ? {
    true    => "${_name}.service",
    default => "${_name}-${_type}.service",
  }

  include quadlets

  if $user {
    $_username = $user
    $_file_group = pick($group, $user)
    $_user_homedir = pick($homedir, "/home/${user}")
    $_quadlet_dir = "${_user_homedir}/${quadlets::quadlet_user_dir}"
  } else {
    $_quadlet_dir = $quadlets::quadlet_dir
    $_username = 'root'
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
    owner        => $_username,
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
        Systemd::Daemon_reload[$quadlet] ~> Systemd::User_service[$_service]
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
        Systemd::Daemon_reload[$quadlet] ~> Service[$_service]
      }
    }
  }
}
