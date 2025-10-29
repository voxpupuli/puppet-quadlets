# @summary Generate and manage podman quadlet user
#
# @param user Specify username
# @param group Specify group ownership of quadlet directories, if `undef` it will be set equal to the username.
# @param homedir Home directory, if `undef` `/home/$user` will be used.
# @param create_dir If true the directory for containers will be created at `$homedir/.config/contaners/systemd`.
# @param manage_user If true the user and group will be created.
# @param manage_linger If true `systemd --user` will be started for user.
#
# @example Run a CentOS user Container maning user, specifying home dir
#   quadlets::user { 'steve':
#     user                => 'steve'
#     create_dir          => true,
#     manage_user         => true,
#     manage_linger       => true,
#     homedir             => '/nfs/home/steve',
#   }
#   quadlets::quadlet{ 'centos.container':
#     ensure              => present,
#     user                => 'steve',
#     homedir             => '/nfs/home/steve',
#     unit_entry          => {
#      'Description'      => 'Trivial Container that will be very lazy',
#     },
#     service_entry       => {
#       'TimeoutStartSec' => '900',
#     },
#     container_entry     => {
#       'Image'           => 'quay.io/centos/centos:latest',
#       'Exec'            => 'sh -c "sleep inf"'
#     },
#     install_entry       => {
#       'WantedBy'        => 'default.target'
#     },
#     active              => true,
#   }
#
define quadlets::user (
  Optional[String[1]] $user = $name,
  Optional[String[1]] $group = undef,
  Optional[Stdlib::Unixpath] $homedir = undef,
  Boolean $create_dir = true,
  Boolean $manage_user = true,
  Boolean $manage_linger = true,
) {
  include quadlets

  $_file_group = pick($group, $user)
  $_user_homedir = pick($homedir, "/home/${user}")

  if $create_dir {
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
      owner  => $user,
      group  => $_file_group,
    }
  }
  if $manage_user {
    group { $_file_group: }

    user { $user:
      ensure     => present,
      gid        => $_file_group,
      home       => $_user_homedir,
      managehome => true,
    }
  }
  if $manage_linger {
    loginctl_user { $user:
      linger => enabled,
    }
  }
}
