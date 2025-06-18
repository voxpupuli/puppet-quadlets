# @summary custom datatype for Network entries of podman container quadlet
# @see https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html
type Quadlets::Unit::Network = Struct[
  Optional['ContainersConfModule'] => Variant[Stdlib::Unixpath,Array[Stdlib::Unixpath,1]],
  Optional['DisableDNS']           => Boolean,
  Optional['DNS']                  => String[1],
  Optional['Driver']               => String[1],
  Optional['Gateway']              => String[1],
  Optional['GlobalArgs']           => Variant[String[1],Array[String[1],1]],
  Optional['Internal']             => Boolean,
  Optional['IPAMDriver']           => String[1],
  Optional['IPRange']              => String[1],
  Optional['IPv6']                 => Boolean,
  Optional['Label']                => Variant[String[1],Array[String[1],1]],
  Optional['NetworkDeleteOnStop']  => Boolean,
  Optional['NetworkName']          => String[1],
  Optional['Options']              => String[1],
  Optional['PodmanArgs']           => Variant[String[1],Array[String[1]]],
  Optional['Subnet']               => String[1],
]
