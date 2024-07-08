# Quadlets

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


