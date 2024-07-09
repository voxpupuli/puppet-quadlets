# @summary custom datatype for container entries of podman container quadlet
# @see https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html
type Quadlets::Unit::Container = Struct[
  Optional['AddCapability'] => Array[String[1],1],
  Optional['Annotation'] => Array[String[1],1],
  Optional['AutoUpdate']  => Enum['registry','local'],
  Optional['ContainerName'] => String[1],
  Optional['DNS'] => Array[Stdlib::IP::Address,0],
  Optional['DNSOption'] => Array[String[1],0],
  Optional['DNSSearch'] => Array[Stdlib::Fqdn,0],
  Optional['DropCapability'] => Array[String[1],0],
  Optional['Environment'] => Array[String[1],0],
  Optional['EnvironmentFile'] => Array[String[1],0],
  Optional['Exec'] => String[1],
  Optional['ExposeHostPort'] => Array[Stdlib::Port,0],
  Optional['GIDMap'] => Array[String[1],0],
  Optional['GlobalArgs'] => Array[String[1],0],
  Optional['Group'] => Integer[0],
  Optional['HealthCmd'] => String[1],
  Optional['HealthOnFailure'] => Enum['none','kill','restart','stop'],
  Optional['HealthStartPeriod'] => String[1],
  Optional['HealthStartupCmd'] => String[1],
  Optional['HealthStartupInterval'] => Variant[Enum['disable'],Integer[0]],
  Optional['HealthStartupTimeout'] => String[1],
  Optional['HealthTimeout'] => String[1],
  Optional['Image'] => String[1],
  Optional['IP'] => Stdlib::IP::Address::V4,
  Optional['IP6'] => Stdlib::IP::Address::V6,
  Optional['Label'] => Variant[String[1],Array[String[1],1]],
  Optional['LogDriver'] => Enum['k8s-file','journald','none','passthrough'],
  Optional['Mask'] => String[1],
  Optional['Mount'] => Array[String[1],0],
  Optional['Network'] => String[1],
  Optional['NoNewPrivileges'] => Boolean,
  Optional['Notify'] => Boolean,
  Optional['PidsLimits'] => Integer[-1],
  Optional['Pod'] => Pattern[/^[a-zA-Z0-0_-]+\.pod$/],
  Optional['PodmanArgs'] => Array[String[1],0],
  Optional['PublishPort'] => Array[Variant[Stdlib::Port,String[1]],1],
  Optional['Pull'] => Enum['always','missing','never','newer'],
  Optional['ReadOnly'] => Boolean,
  Optional['ReadOnlyTmpfs'] => Boolean,
  Optional['Rootfs'] => String[1],
  Optional['RunInit'] => Boolean,
  Optional['SeccompProfile'] => String[1],
  Optional['Secret'] => Array[String[1],0],
  Optional['SecurityLabelDisable'] => Boolean,
  Optional['SecurityLabelFileType'] => String[1],
  Optional['SecurityLabelNested'] => Boolean,
  Optional['ShmSize'] => String[1],
  Optional['StopTimeout'] => Integer[1],
  Optional['SubGIDMap'] => String[1],
  Optional['SubUIDMap'] => String[1],
  Optional['Sysctl'] => Array[String[1],0],
  Optional['Timezone'] => String[1],
  Optional['Tmpfs'] => Array[String[1],0],
  Optional['UIDMap'] => Array[String[1],0],
  Optional['Ulimit'] => String[1],
  Optional['Unmask'] => String[1],
  Optional['User'] => String[1],
  Optional['UserNS'] => String[1],
  Optional['Volume'] => Array[String[1],0],
  Optional['WorkingDir'] => Stdlib::Unixpath,
]