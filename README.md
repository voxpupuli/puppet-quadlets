# Quadlets

[![Build Status](https://github.com/voxpupuli/puppet-quadlets/workflows/CI/badge.svg)](https://github.com/voxpupuli/puppet-quadlets/actions?query=workflow%3ACI)
[![Release](https://github.com/voxpupuli/puppet-quadlets/actions/workflows/release.yml/badge.svg)](https://github.com/voxpupuli/puppet-quadlets/actions/workflows/release.yml)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/quadlets.svg)](https://forge.puppetlabs.com/puppet/quadlets)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/quadlets.svg)](https://forge.puppetlabs.com/puppet/quadlets)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/quadlets.svg)](https://forge.puppetlabs.com/puppet/quadlets)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/quadlets.svg)](https://forge.puppetlabs.com/puppet/quadlets)
[![puppetmodule.info docs](http://www.puppetmodule.info/images/badge.png)](http://www.puppetmodule.info/m/puppet-quadlets)
[![Apache-2 License](https://img.shields.io/github/license/voxpupuli/puppet-quadlets.svg)](LICENSE)

## Overview

Manages Podman and Podman Quadlets in particular

## Example

Create a simple `centos.service` running a container from a CentOS image.

```puppet
quadlets::quadlet{'centos.container':
  ensure          => present,
  unit_entry     => {
   'Description' => 'Trivial Container that will be very lazy',
  },
  service_entry       => {
    'TimeoutStartSec' => '900',
  },
  container_entry => {
    'Image' => 'quay.io/centos/centos:latest',
    'Exec'  => 'sh -c "sleep inf"'
  },
  install_entry   => {
    'WantedBy' => 'default.target'
  },
  active          => true,
}
```

## Reference

The reference of the quadlet module see [REFERENCE.md](REFERENCE.md)
