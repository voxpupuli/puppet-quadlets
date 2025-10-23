# @summary custom datatype for Volume entries of podman container quadlet
# @see https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html
type Quadlets::Unit::Pod = Struct[
  Optional['ContainersConfModule'] => Variant[Stdlib::Unixpath,Array[Stdlib::Unixpath,1]],
  Optional['GlobalArgs']           => Variant[String[1],Array[String[1],1]],
  Optional['Network']              => String[1],
  Optional['PodmanArgs']           => Variant[String[1],Array[String[1]]],
  Optional['PodName']              => String[1],
  Optional['PublishPort']          => Array[Variant[Stdlib::Port,String[1]],1],
  Optional['UserNS']               => String[1],
  Optional['Volume']               => Variant[String[1],Array[String[1],]],
  Optional['HostName']             => Variant[String[1],Array[String[1],1]],
  Optional['Label']                => Variant[String[1],Array[String[1],1]],
]
