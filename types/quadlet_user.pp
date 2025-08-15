# @summary custom datatype for container entries of podman container quadlet
# @see https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html
type Quadlets::Quadlet_user = Struct[
  name => String[1],
  Optional['group'] => String[1],
  Optional['homedir'] => String[1],
]
