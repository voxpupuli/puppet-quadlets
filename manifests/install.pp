# @summary Install podman software for quadlet support
# @api private
#
class quadlets::install {
  package { 'podman':
    ensure => installed,
  }
}
