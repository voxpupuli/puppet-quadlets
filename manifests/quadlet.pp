# @summary Generate and manage podman quadlet definitions (podman > 4.4.0)
#
# @see podman-systemd.unit.5 https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html
#
# @param quadlet of the quadlet file this is the namevar.
# @param ensure State of the container definition.
# @param mode Filemode of container file.
# @param active Make sure the container is running.
# @param user Specify which user to run as
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
#   quadlets::quadlet{'centos.container':
#     ensure          => present,
#     unit_entry     => {
#      'Description' => 'Trivial Container that will be very lazy',
#     },
#     service_entry       => {
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
# @example Run a Pod using a kubernetes Yaml definition
#   quadlets::quadlet{'centos.container':
#     ensure          => present,
#     unit_entry     => {
#      'Description' => 'Pod running my application',
#     },
#     kube_entry => {
#       'Yaml' => '/path/to/yaml/file.yaml',
#     },
#     install_entry   => {
#       'WantedBy' => 'default.target'
#     },
#     active          => true,
#   }
#
# @example Run a CentOS user Container specifying home dir
#   quadlets::quadlet{'centos.container':
#     ensure          => present,
#     user            =>
#      'name'    => 'containers',
#      'homedir' => '/nfs/home/containers',
#     },
#     unit_entry     => {
#      'Description' => 'Trivial Container that will be very lazy',
#     },
#     service_entry       => {
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
# @example Run a CentOS user Container without managing the aspects of the user
#   quadlets::quadlet{'centos.container':
#     ensure          => present,
#     user            =>
#      'name'          => 'containers',
#      'create_dir'    => false,
#      'manage_user'   => false,
#      'manage_linger' => false,
#     },
#     unit_entry     => {
#      'Description' => 'Trivial Container that will be very lazy',
#     },
#     service_entry       => {
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
  Stdlib::Filemode $mode = '0444',
  Optional[Boolean] $active = undef,
  Optional[Quadlets::Quadlet_user] $user = undef,
  Optional[Systemd::Unit::Install] $install_entry = undef,
  Optional[Systemd::Unit::Unit] $unit_entry = undef,
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
  # Validate the input and find the service name.
  case $_type {
    'container': {
      if $volume_entry or $pod_entry or $image_entry or $network_entry {
        fail('A volume_entry, pod_entry, image_entry or network_entry makes no sense on a container quadlet')
      }
      $_service = "${_name}.service"
    }
    'volume': {
      if $container_entry or $pod_entry or $kube_entry or $image_entry or $network_entry {
        fail('A container_entry, pod_entry, kube_entry, network_entry or image_entry makes no sense on a volume quadlet')
      }
      $_service = "${_name}-volume.service"
    }
    'network': {
      if $container_entry or $pod_entry or $kube_entry or $image_entry or $volume_entry {
        fail('A container_entry, pod_entry, volume_entry, image_entry or kube_entry makes no sense on a network quadlet')
      }
      $_service = "${_name}-network.service"
    }
    'pod': {
      if $container_entry or $volume_entry or $kube_entry or $image_entry or $network_entry {
        fail('A container_entry, volume_entry, kube_entry, network_entry or image_entry makes no sense on a pod quadlet')
      }
      $_service = "${_name}-pod.service"
    }
    'kube': {
      if $volume_entry or $pod_entry or $container_entry or $image_entry or $network_entry {
        fail('A container_entry, pod_entry, volume_entry, network_entry  or image_entry makes no sense on a kube quadlet')
      }
      $_service = "${_name}.service"
    }
    'image': {
      if $volume_entry or $pod_entry or $container_entry or $kube_entry or $network_entry {
        fail('A container_entry, pod_entry, volume_entry, network_entry or kube_entry makes no sense on an image quadlet')
      }
      $_service = "${_name}.service"
    }
    default: {
      fail('Should never be here due to typing on quadlet')
    }
  }

  include quadlets

  if $user {
    $username = $user['name']
    $file_group = pick($user['group'], $user['name'])
    $user_homedir = pick($user['homedir'], "/home/${user['name']}")
    $quadlet_file = "${user_homedir}/${quadlets::quadlet_user_dir}/${quadlet}"
    $create_dir = pick($user['create_dir'], true)
    $manage_user = pick($user['manage_user'], true)
    $manage_linger = pick($user['manage_linger'], true)

    if $create_dir {
      $components = split($quadlets::quadlet_user_dir, '/')
      $dirs = $components.reduce([]) |$accum, $part| {
        $accum + [$accum ? {
            []      => "${user_homedir}/${part}",
            default => "${accum[-1]}/${part}"
          }
        ]
      }
      ensure_resource('file', $dirs, {
          ensure => directory,
          owner  => $username,
          group  => $file_group,
        }
      )
    }
    if $manage_user {
      ensure_resource('user', $username, {
          ensure     => present,
          managehome => true,
        }
      )
    }
    if $manage_linger {
      ensure_resource('loginctl_user', $username, {
          linger => enabled,
        }
      )
    }
  } else {
    $quadlet_file = "${quadlets::quadlet_dir}/${quadlet}"
    $username = 'root'
    $file_group = 'root'
  }

  file { $quadlet_file:
    ensure  => $ensure,
    owner   => $username,
    group   => $file_group,
    mode    => $mode,
    content => epp('quadlets/quadlet_file.epp', {
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

  ensure_resource('systemd::daemon_reload', $quadlet, { 'user' => $user.dig('name') })
  File[$quadlet_file] ~> Systemd::Daemon_reload[$quadlet]

  if $active != undef {
    if $user {
      systemd::user_service { $_service:
        ensure => $active,
        enable => $active,
        user   => $user['name'],
      }

      if $ensure == 'absent' {
        Systemd::User_service[$_service] -> File[$quadlet_file]
        File[$quadlet_file] ~> Systemd::Daemon_reload[$quadlet]
      } else {
        File[$quadlet_file] ~> Systemd::User_service[$_service]
        Systemd::Daemon_reload[$quadlet] ~> Systemd::User_service[$_service]
      }
    } else {
      service { $_service:
        ensure => $active,
      }

      if $ensure == 'absent' {
        Service[$_service] -> File[$quadlet_file]
        File[$quadlet_file] ~> Systemd::Daemon_reload[$quadlet]
      } else {
        File[$quadlet_file] ~> Service[$_service]
        Systemd::Daemon_reload[$quadlet] ~> Service[$_service]
      }
    }
  }
}
