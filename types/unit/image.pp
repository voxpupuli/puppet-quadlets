# @summary custom datatype for Image entries of podman image quadlet
# @see https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html
type Quadlets::Unit::Image = Struct[
  Optional['AllTags'] => Boolean,
  Optional['Arch'] => String[1],
  Optional['AuthFile'] => Stdlib::Unixpath,
  Optional['CertDir'] => Stdlib::Unixpath,
  Optional['ContainersConfModule'] => Variant[Array[Stdlib::Unixpath, 1], Stdlib::Unixpath],
  Optional['Creds'] => String[1],
  Optional['DecryptionKey'] => String[1],
  Optional['GlobalArgs'] => Variant[Array[String[1], 0], String[1]],
  Optional['Image'] => String[1],
  Optional['ImageTag'] => String[1],
  Optional['OS'] => String[1],
  Optional['PodmanArgs'] => Variant[Array[String[1], 0], String[1]],
  Optional['Policy'] => Enum['always','missing','never','newer'],
  Optional['Retry'] => Integer[1],
  Optional['RetryDelay'] => String[1],
  Optional['TLSVerify'] => Boolean,
  Optional['Variant'] => String[1],
]
