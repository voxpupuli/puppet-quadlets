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

### Simple `rootless` `centos.service` Running a Container

The quadlet file will be maintained at `/etc/containers/systemd/users/santa/centos.container`

```puppet
quadlets::user { 'santa':
  create_dir    => true,
  manage_user   => true,
  manage_linger => true,
  homedir       => "/home/santa",

}
quadlets::quadlet { "centos.container":
   ensure          => present,
   location        => 'system',
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
