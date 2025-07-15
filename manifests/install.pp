# @summary Install podman software for quadlet support
# @api private
#
class quadlets::install (
  Boolean $manage_package = $quadlets::manage_package,
  Array[String[1,]] $package_names = $quadlets::package_names,
  Stdlib::Ensure::Package $package_ensure = $quadlets::package_ensure,
) {
  if $manage_package {
    package { $package_names:
      ensure => $package_ensure,
    }
  }
}
