# @summary custom datatype for Kube entries of podman kube quadlet
# @see https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html
type Quadlets::Unit::Kube = Struct[
  Optional['AutoUpdate'] => Array[String[1], 1],
  Optional['ConfigMap']  => Array[Stdlib::Unixpath, 1],
  Optional['ContainersConfModule'] => Array[Stdlib::Unixpath, 1],
  Optional['ExitCodePropagation'] => Enum['all', 'any', 'none'],
  Optional['GlobalArgs'] => Array[String[1], 0],
  Optional['KubeDownForce'] => Boolean,
  Optional['LogDriver'] => String[1],
  Optional['Network'] => Array[String[1], 1],
  Optional['PodmanArgs'] => Array[String[1], 0],
  Optional['PublishPort'] => Array[Variant[Stdlib::Port,String[1]],1],
  Optional['SetWorkingDirectory'] => Enum['yaml', 'unit'],
  Optional['UserNS'] => String[1],
  Optional['Yaml'] => Stdlib::Unixpath,
]
