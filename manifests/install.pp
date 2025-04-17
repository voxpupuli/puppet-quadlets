# @summary Install podman software for quadlet support
# @api private
#
class quadlets::install {
  stdlib::ensure_packages(['podman'])
}
