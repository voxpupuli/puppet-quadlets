# @summary Generate and manage podman quadlet user
#
# @param user Specify username
# @param group Specify group ownership of quadlet directories, if `undef` it will be set equal to the username.
# @param homedir Home directory, if `undef` `/home/$user` will be used.
# @param create_dir If true the directory for podlets will be created at `$homedir/.config/containers/systemd`.
# @param create_system_dir If true the directory `/etc/containers/systemd/user/$user` will be created.
# @param manage_user If true the user and group will be created.
# @param manage_linger If true `systemd --user` will be started for user.
# @param subuid If defined as a pair of integers the user will have a subordintate user ID and a subordinate user ID count specified in `/etc/subuid`. Only one range per user is supported,
# @param subgid If defined as a pair of integers the user's group will have a subordintate group ID and a subordinate group ID count specified in `/etc/subgid`. Only one range per group is supported,
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
# @example Specify subordinate start and size
#   quadlets::user { 'quark':
#      name   => 'quark',
#      subuid => [10000, 15000],
#      subgid => [10000, 15000],
#   }
#
define quadlets::user (
  Optional[String[1]] $user = $name,
  Optional[String[1]] $group = undef,
  Optional[Stdlib::Unixpath] $homedir = undef,
  Boolean $create_dir = true,
  Boolean $create_system_dir = true,
  Boolean $manage_user = true,
  Boolean $manage_linger = true,
  Optional[Tuple[Integer[1],Integer[1]]] $subuid = undef,
  Optional[Tuple[Integer[1],Integer[1]]] $subgid = undef,
) {
  include quadlets

  $_group = pick($group, $user)
  $_user_homedir = pick($homedir, "/home/${user}")

  if $create_system_dir {
    file { "${quadlets::quadlet_system_user_dir}/${user}":
      ensure => directory,
      owner  => root,
      group  => root,
    }
  }

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
      group  => $_group,
    }
  }
  if $manage_user {
    group { $_group: }

    user { $user:
      ensure     => present,
      gid        => $_group,
      home       => $_user_homedir,
      managehome => true,
    }
  }
  if $manage_linger {
    loginctl_user { $user:
      linger => enabled,
    }
  }

  #
  # Manage subordinate users
  #
  if $subuid {
    augeas { "subuid_${user}":
      incl    => '/etc/subuid',
      lens    => 'Subids.lns',
      context => '/files/etc/subuid',
      changes => [
        "set ${user}/start ${subuid[0]}",
        "set ${user}/count ${subuid[1]}",
        "rm ${user}[2]",
        "rm ${user}[2]",
        "rm ${user}[2]",
      ],
    }
    if $manage_user {
      User[$user] -> Augeas["subuid_${user}"]
    }
  }
  if $subgid {
    augeas { "subgid_${_group}":
      incl    => '/etc/subgid',
      lens    => 'Subids.lns',
      context => '/files/etc/subgid',
      changes => [
        "set ${_group}/start ${subgid[0]}",
        "set ${_group}/count ${subgid[1]}",
        "rm ${_group}[2]",
        "rm ${_group}[2]",
        "rm ${_group}[2]",
      ],
    }
    if $manage_user {
      Group[$_group] -> Augeas["subgid_${_group}"]
    }
  }
}
