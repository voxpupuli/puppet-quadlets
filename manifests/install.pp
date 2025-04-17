# @summary Install podman software for quadlet support
# @api private
#
class quadlets::install (
  Boolean $manage_package = $quadlets::manage_package,
) {
  if $manage_package {
    package { 'podman':
      ensure => installed,
    }
  }
}
