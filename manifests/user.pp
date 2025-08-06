# @summary Generate and manage podman quadlet user
#
# @param user Specify user with options
#
# @example Run a CentOS user Container maning user, specifying home dir
#   $_steve = {
#     'name'          => 'steve',
#     'create_dir'    => true,
#     'manage_user'   => true,
#     'manage_linger' => true,
#     'homedir'       => '/nfs/home/steve',
#   }
#   quadlets::user { 'steve':
#     user => $_steve,
#   }
#   quadlets::quadlet{ 'centos.container':
#     ensure          => present,
#     user            => $_steve,
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
define quadlets::user (
  Quadlets::Quadlet_user $user,
) {
  include quadlets

  $_username = $user['name']
  $_file_group = pick($user['group'], $user['name'])
  $_user_homedir = pick($user['homedir'], "/home/${user['name']}")
  $_create_dir = pick($user['create_dir'], true)
  $_manage_user = pick($user['manage_user'], true)
  $_manage_linger = pick($user['manage_linger'], true)

  if $_create_dir {
    $components = split($quadlets::quadlet_user_dir, '/')
    $dirs = $components.reduce([]) |$accum, $part| {
      $accum + [$accum ? {
          []      => "${_user_homedir}/${part}",
          default => "${accum[-1]}/${part}"
        }
      ]
    }
    file { $dirs:
      ensure => directory,
      owner  => $_username,
      group  => $_file_group,
    }
  }
  if $_manage_user {
    user { $_username:
      ensure     => present,
      home       => $_user_homedir,
      managehome => true,
    }
  }
  if $_manage_linger {
    loginctl_user { $_username:
      linger => enabled,
    }
  }
}
