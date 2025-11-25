# @summary custom datatype for Kube entries of podman kube quadlet
# @see https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html
type Quadlets::Unit::Kube = Struct[
  Optional['AutoUpdate'] => Variant[Array[String[1], 1], String[1]],
  Optional['ConfigMap']  => Variant[Array[Stdlib::Unixpath, 1], Stdlib::Unixpath],
  Optional['ContainersConfModule'] => Variant[Array[Stdlib::Unixpath, 1], Stdlib::Unixpath],
  Optional['ExitCodePropagation'] => Enum['all', 'any', 'none'],
  Optional['GlobalArgs'] => Variant[Array[String[1], 0], String[1]],
  Optional['KubeDownForce'] => Boolean,
  Optional['LogDriver'] => String[1],
  Optional['Network'] => Variant[Array[String[1], 1], String[1]],
  Optional['PodmanArgs'] => Variant[Array[String[1], 0], String[1]],
  Optional['PublishPort'] => Variant[Array[Variant[Stdlib::Port,String[1]],1], Variant[Stdlib::Port,String[1]]],
  Optional['SetWorkingDirectory'] => Enum['yaml', 'unit'],
  Optional['UserNS'] => String[1],
  Optional['Yaml'] => Stdlib::Unixpath,
]
