# Quadlets

[![Build Status](https://github.com/voxpupuli/puppet-quadlets/workflows/CI/badge.svg)](https://github.com/voxpupuli/puppet-quadlets/actions?query=workflow%3ACI)
[![Release](https://github.com/voxpupuli/puppet-quadlets/actions/workflows/release.yml/badge.svg)](https://github.com/voxpupuli/puppet-quadlets/actions/workflows/release.yml)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/quadlets.svg)](https://forge.puppetlabs.com/puppet/quadlets)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/quadlets.svg)](https://forge.puppetlabs.com/puppet/quadlets)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/quadlets.svg)](https://forge.puppetlabs.com/puppet/quadlets)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/quadlets.svg)](https://forge.puppetlabs.com/puppet/quadlets)
[![puppetmodule.info docs](https://www.puppetmodule.info/images/badge.svg)](https://www.puppetmodule.info/m/puppet-quadlets)
[![Apache-2 License](https://img.shields.io/github/license/voxpupuli/puppet-quadlets.svg)](LICENSE)

## Overview

Manages Podman and Podman Quadlets in particular

## Example

### Simple `rootful` `centos.service` Running a Container

```puppet
quadlets::quadlet { 'centos.container':
  ensure          => present,
  unit_entry      => {
    'Description' => 'Trivial Container that will be very lazy',
  },
  service_entry   => {
    'TimeoutStartSec' => '900',
  },
  container_entry => {
    'Image' => 'quay.io/centos/centos:latest',
    'Exec'  => 'sh -c "sleep inf"',
  },
  install_entry   => {
    'WantedBy' => 'default.target',
  },
  active          => true,
}
```

### Simple `rootless` `centos.service` Running a Container

The quadlet file will be maintained at `/home/santa/.config/containers/systemd/centos.container`


```puppet
quadlets::user { 'santa':
  create_dir    => true,
  manage_user   => true,
  manage_linger => true,
  homedir       => "/home/santa",

}
quadlets::quadlet { "centos.container":
   ensure          => present,
   user            => 'santa',
   unit_entry      => {
     'Description' => 'Trivial Container that will be very lazy',
   },
   container_entry => {
     'Image' => 'quay.io/centos/centos:latest',
     'Exec'  => 'sh -c "sleep inf"',
   },
   install_entry   => {
     'WantedBy' => 'default.target',
   },
   active          => true,
   require         => Quadlets::User['santa'],
 }
```

### Simple `rootless` `centos.service` Running a Container with a Network

The quadlet files will be maintained in `/etc/containers/systemd/users/santa`

```puppet
quadlets::user { 'santa':
  create_dir    => true,
  manage_user   => true,
  manage_linger => true,
  homedir       => "/home/santa",

}

# Set defaults for all the quadlets belonging to "santa".
Quadlets::Quadlet {
  ensure   => 'present',
  location => 'system',
  user     => 'santa',
  active   => 'true',
}

quadlets::quadlet { "centos.container":
  unit_entry      => {
    'Description' => 'Trivial Container that will be very lazy',
  },
  container_entry => {
    'Image'   => 'quay.io/centos/centos:latest',
    'Exec'    => 'sh -c "sleep inf"',
    'Network' => 'centos.network',
  },
  install_entry   => {
    'WantedBy' => 'default.target',
  },
  require         => Quadlets::Quadlet['centos.network'],
}

quadlets::quadlet { "centos.network":
  unit_entry      => {
    'Description' => 'Trivial Network',
  },
  network_entry => {
    'Subnet'  => '192.168.30.0/24',
    'Gateway' => '192.168.30.1',
  },
  install_entry   => {
    'WantedBy' => 'default.target',
  },
}
```

### Hiera Representation Of User setup and Quadlet deployment

```yaml
quadlets::users_hash:
  charlie: {}
  lucy:
    homedir: '/opt/lucy'

quadlets::quadlets_hash:
  centos.container:
    user: 'charlie'
    location: 'system'
    container_entry:
      Image: 'quay.io/centos/centos:latest'
      Exec: 'sh -c "sleep inf"'
      Network: 'centos.network'
    require: 'Quadlets::Quadlet[centos.network]'
  centos.network:
    user: 'charlie'
    location: 'system'
    network_entry:
      Subnet: '192.168.30.0/24'
      Gateway: '192.168.30.1'
  busybox.image:
    user: 'lucy'
    homedir: '/opt/lucy'
    unit_entry:
      Description: 'Busybox Image'
    image_entry:
      Image: 'docker.io/busybox'
```

## Migrating from version 2 to version 3

With version 3 the method for defining rootless containers has changed in a completely backwards incompatible way.
For rootful containers the situation is unchanged.

* The type `Quadlets::Quadlet_user` is completely removed.
* The `quadlets::user` definition is as above.
* The `qaudlets::quadlet` parameters now expects the `user` parameter as a user name and can have the `group` and `homedir` provided if something is required beyond the default behaviour.

The motivation for migration was to make the module more obvious and easier to document.

By example:

```puppet
# Old v2 configuration
$_user = {
  name          => 'container',
  homedir       => '/nfs/home/cont'
  manage_linger => true,
}

quadlets::user{'container':
  user => $_user,
}

quadlets::quadlet{ 'my.pod':
  ensure  => 'present',
  user    => $_user,
  unit    => {
    'Description' => 'Simple Pod',
  }
  require => Quadlet::Quadlet['container'],
}
```

now becomes

```puppet
# New v3 configuration
quadlets::user{'container':
  homedir       => '/nfs/home/cont',
  manage_linger => true,
}

quadlets::quadlet{ 'my.pod':
  ensure  => 'present',
  user    => 'container',
  homedir => '/nfs/home/cont',
  unit    => {
    'Description' => 'Simple Pod',
  },
  require => Quadlet::Quadlet['container'],
}
```

The end result is identical.

## Quadlets Fact

The podman version can be accessed via the `quadlets` fact.

```
facter quadlets
{
  podman_version => "5.4.0"
}
```

## Reference

The reference of the quadlet module see [REFERENCE.md](REFERENCE.md)
