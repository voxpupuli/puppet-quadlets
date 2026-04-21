# frozen_string_literal: true

require 'spec_helper'

describe 'Quadlets::Unit::Container' do
  it { is_expected.to allow_value({ 'AddCapability' => 'CAP_DAC_OVERRIDE' }) }
  it { is_expected.to allow_value({ 'AddCapability' => %w[CAP_DAC_OVERRIDE CAP_IPC_OWNER] }) }
  it { is_expected.to allow_value({ 'AddDevice' => 'nvidia.com/gpu=all' }) }
  it { is_expected.to allow_value({ 'AddDevice' => ['nvidia.com/gpu=all', '/dev/sda'] }) }
  it { is_expected.to allow_value({ 'AddHost' => ['db.internal:192.168.20.10', 'redis.internal:192.168.20.11'] }) }
  it { is_expected.to allow_value({ 'AddHost' => 'redis.internal:192.168.20.11' }) }
  it { is_expected.to allow_value({ 'Annotation' => 'key=value' }) }
  it { is_expected.to allow_value({ 'Annotation' => ['key=value', 'another.key=somevalue'] }) }
  it { is_expected.to allow_value({ 'AppArmor' => 'docker-default' }) }
  it { is_expected.to allow_value({ 'AppArmor' => 'unconfined' }) }
  it { is_expected.not_to allow_value({ 'AutoUpdate' => 'random' }) }
  it { is_expected.to allow_value({ 'AutoUpdate' => 'registry' }) }
  it { is_expected.to allow_value({ 'AutoUpdate' => 'local' }) }
  it { is_expected.not_to allow_value({ 'CgroupsMode' => 'random' }) }
  it { is_expected.to allow_value({ 'CgroupsMode' => 'enabled' }) }
  it { is_expected.to allow_value({ 'CgroupsMode' => 'disabled' }) }
  it { is_expected.to allow_value({ 'CgroupsMode' => 'no-conmon' }) }
  it { is_expected.to allow_value({ 'CgroupsMode' => 'split' }) }
  it { is_expected.to allow_value({ 'ContainerName' => 'my-app' }) }
  it { is_expected.to allow_value({ 'ContainersConfModule' => ['log_driver=journald', 'runtime=crun'] }) }
  it { is_expected.to allow_value({ 'ContainersConfModule' => 'pids_limit=2048' }) }
  it { is_expected.to allow_value({ 'DNS' => ['192.168.1.1', '10.0.0.53'] }) }
  it { is_expected.to allow_value({ 'DNSOption' => 'ndots:1' }) }
  it { is_expected.to allow_value({ 'DNSOption' => ['ndots:1', 'timeout:2'] }) }
  it { is_expected.to allow_value({ 'DNSSearch' => 'example.com' }) }
  it { is_expected.to allow_value({ 'DNSSearch' => ['example.com', 'svc.cluster.local'] }) }
  it { is_expected.to allow_value({ 'DropCapability' => 'CAP_NET_RAW' }) }
  it { is_expected.to allow_value({ 'DropCapability' => %w[CAP_NET_RAW CAP_SYS_ADMIN] }) }
  it { is_expected.to allow_value({ 'Entrypoint' => 'python3' }) }
  it { is_expected.to allow_value({ 'Entrypoint' => '["/usr/bin/sleep", "inf"]' }) }
  it { is_expected.to allow_value({ 'Environment' => 'FOO=bar' }) }
  it { is_expected.to allow_value({ 'Environment' => RSpec::Puppet::Sensitive.new('SECRET=pass') }) }
  it { is_expected.to allow_value({ 'Environment' => ['FOO=bar', 'BAZ=qux', RSpec::Puppet::Sensitive.new('SECRET=pass')] }) }
  it { is_expected.to allow_value({ 'EnvironmentFile' => '/etc/myenv.conf' }) }
  it { is_expected.to allow_value({ 'EnvironmentFile' => ['/etc/myenv.conf', '/opt/app/env.list'] }) }
  it { is_expected.to allow_value({ 'EnvironmentHost' => 'HOME' }) }
  it { is_expected.to allow_value({ 'EnvironmentHost' => %w[HOME PATH] }) }
  it { is_expected.to allow_value({ 'Exec'  => '/bin/bash' }) }
  it { is_expected.to allow_value({ 'Exec'  => './entrypoint.sh' }) }
  it { is_expected.to allow_value({ 'ExposeHostPort' => 8080 }) }
  it { is_expected.to allow_value({ 'ExposeHostPort' => [8080, 8443] }) }
  it { is_expected.to allow_value({ 'GIDMap' => '0:100000:65536' }) }
  it { is_expected.to allow_value({ 'GIDMap' => ['0:100000:65536', '65536:200000:65536'] }) }
  it { is_expected.to allow_value({ 'GlobalArgs' => '--log-level=debug' }) }
  it { is_expected.to allow_value({ 'GlobalArgs' => ['--log-level=debug', '--cgroup-manager=systemd'] }) }
  it { is_expected.to allow_value({ 'Group' => 'appgroup' }) }
  it { is_expected.to allow_value({ 'Group' => 1000 }) }
  it { is_expected.to allow_value({ 'GroupAdd' => 'wheel' }) }
  it { is_expected.to allow_value({ 'HealthCmd' => '/usr/bin/checkme --verywell' }) }
  it { is_expected.to allow_value({ 'HealthCmd' => '["/usr/bin/checkme --verywell","/bin/can-be-json-string-also-allow"]' }) }
  it { is_expected.to allow_value({ 'HealthInterval' => 30 }) }
  it { is_expected.to allow_value({ 'HealthInterval' => 'disable' }) }
  it { is_expected.not_to allow_value({ 'HealthLogDestination' => 'random-string' }) }
  it { is_expected.to allow_value({ 'HealthLogDestination' => 'events_logger' }) }
  it { is_expected.to allow_value({ 'HealthLogDestination' => 'local' }) }
  it { is_expected.to allow_value({ 'HealthLogDestination' => '/var/log/health.log' }) }
  it { is_expected.to allow_value({ 'HealthMaxLogCount' => 10 }) }
  it { is_expected.to allow_value({ 'HealthMaxLogSize' => 3000 }) }
  it { is_expected.not_to allow_value({ 'HealthOnFailure' => 'random-string' }) }
  it { is_expected.to allow_value({ 'HealthOnFailure' => 'none' }) }
  it { is_expected.to allow_value({ 'HealthOnFailure' => 'kill' }) }
  it { is_expected.to allow_value({ 'HealthOnFailure' => 'restart' }) }
  it { is_expected.to allow_value({ 'HealthOnFailure' => 'stop' }) }
  it { is_expected.to allow_value({ 'HealthRetries' => 1 }) }
  it { is_expected.to allow_value({ 'HealthStartPeriod' => 10 }) }
  it { is_expected.to allow_value({ 'HealthStartupCmd' => '["/usr/bin/checkme --verywell","/bin/can-be-json-string-also-allow"]' }) }
  it { is_expected.to allow_value({ 'HealthStartupInterval' => 30 }) }
  it { is_expected.to allow_value({ 'HealthStartupRetries' => 8 }) }
  it { is_expected.to allow_value({ 'HealthStartupSuccess' => 2 }) }
  it { is_expected.to allow_value({ 'HealthStartupTimeout' => 1 }) }
  it { is_expected.to allow_value({ 'HealthTimeout' => '2m' }) }
  it { is_expected.to allow_value({ 'HostName' => 'foo.example.net' }) }
  it { is_expected.to allow_value({ 'HostName' => ['foo.example.net'] }) }
  it { is_expected.to allow_value({ 'HttpProxy' => true }) }
  it { is_expected.to allow_value({ 'HttpProxy' => false }) }
  it { is_expected.to allow_value({ 'Image' => 'busybox' }) }
  it { is_expected.to allow_value({ 'Image' => 'quay.io/centos/centos:latest' }) }
  it { is_expected.to allow_value({ 'IP' => '192.168.1.5' }) }
  it { is_expected.not_to allow_value({ 'IP' => '2001:db8::1' }) }
  it { is_expected.to allow_value({ 'IP6' => '2001:db8::1' }) }
  it { is_expected.not_to allow_value({ 'IP6' => '192.168.1.5' }) }
  it { is_expected.to allow_value({ 'Label' => 'org.example.key=value' }) }
  it { is_expected.to allow_value({ 'Label' => ['org.example.key=value', 'version=1.0'] }) }
  it { is_expected.not_to allow_value({ 'LogDriver' => 'random' }) }
  it { is_expected.to allow_value({ 'LogDriver' => 'k8s-file' }) }
  it { is_expected.to allow_value({ 'LogDriver' => 'journald' }) }
  it { is_expected.to allow_value({ 'LogDriver' => 'none' }) }
  it { is_expected.to allow_value({ 'LogDriver' => 'passthrough' }) }
  it { is_expected.to allow_value({ 'LogOpt' => 'path=/var/log/mykube.json' }) }
  it { is_expected.to allow_value({ 'LogOpt' => ['path=/var/log/mykube.json', 'max-size=10mb'] }) }
  it { is_expected.to allow_value({ 'Mask' => '/proc/sys/foo' }) }
  it { is_expected.to allow_value({ 'Memory' => '512m' }) }
  it { is_expected.to allow_value({ 'Memory' => '20g' }) }
  it { is_expected.to allow_value({ 'Mount' => '/data:/mnt/data:rw' }) }
  it { is_expected.to allow_value({ 'Mount' => ['/data:/mnt/data:rw', '/etc/ssl:/ssl:ro'] }) }
  it { is_expected.to allow_value({ 'Network' => 'host' }) }
  it { is_expected.to allow_value({ 'Network' => ['mynet', 'mynet2'] }) }
  it { is_expected.to allow_value({ 'NetworkAlias' => 'webapp' }) }
  it { is_expected.to allow_value({ 'NetworkAlias' => %w[webapp api backend] }) }
  it { is_expected.to allow_value({ 'NoNewPrivileges' => true }) }
  it { is_expected.to allow_value({ 'Notify' => false }) }
  it { is_expected.to allow_value({ 'PidsLimit' => 100 }) }
  it { is_expected.to allow_value({ 'PidsLimit' => -1 }) }
  it { is_expected.not_to allow_value({ 'Pod' => 'foo' }) }
  it { is_expected.to allow_value({ 'Pod' => 'foo1234.pod' }) }
  it { is_expected.to allow_value({ 'Pod' => 'foo-bar.pod' }) }
  it { is_expected.to allow_value({ 'Pod' => 'foo_bar.pod' }) }
  it { is_expected.to allow_value({ 'PodmanArgs' => '--pull never' }) }
  it { is_expected.to allow_value({ 'PodmanArgs' => ['--pull never', '--log-level=debug'] }) }
  it { is_expected.to allow_value({ 'PublishPort' => [1234] }) }
  it { is_expected.to allow_value({ 'PublishPort' => [1234, '123.111.1.1:55:72'] }) }
  it { is_expected.to allow_value({ 'PublishPort' => ['1234-12346'] }) }
  it { is_expected.to allow_value({ 'PublishPort' => '1234:5678' }) }
  it { is_expected.to allow_value({ 'PublishPort' => ['1234:5678'] }) }
  it { is_expected.not_to allow_value({ 'Pull' => 'random' }) }
  it { is_expected.to allow_value({ 'Pull' => 'always' }) }
  it { is_expected.to allow_value({ 'Pull' => 'missing' }) }
  it { is_expected.to allow_value({ 'Pull' => 'never' }) }
  it { is_expected.to allow_value({ 'Pull' => 'newer' }) }
  it { is_expected.to allow_value({ 'ReadOnly' => true }) }
  it { is_expected.to allow_value({ 'ReadOnlyTmpfs' => true }) }
  it { is_expected.to allow_value({ 'ReloadCmd' => '/usr/bin/myapp --reload' }) }
  it { is_expected.to allow_value({ 'ReloadSignal' => 'SIGHUP' }) }
  it { is_expected.to allow_value({ 'Retry' => 5 }) }
  it { is_expected.to allow_value({ 'Retry' => -1 }) }
  it { is_expected.to allow_value({ 'RetryDelay' => '10s' }) }
  it { is_expected.to allow_value({ 'Rootfs' => '/path/to/rootfs:ro' }) }
  it { is_expected.to allow_value({ 'RunInit' => true }) }
  it { is_expected.to allow_value({ 'SeccompProfile' => '/etc/seccomp/myprofile.json' }) }
  it { is_expected.to allow_value({ 'Secret' => ['db_password:ro', 'api_key:rw'] }) }
  it { is_expected.to allow_value({ 'Secret' => 'mysecret:ro' }) }
  it { is_expected.to allow_value({ 'SecurityLabelDisable' => true }) }
  it { is_expected.to allow_value({ 'SecurityLabelFileType' => 'container_file_t' }) }
  it { is_expected.to allow_value({ 'SecurityLabelLevel' => 's0:c123,c456' }) }
  it { is_expected.to allow_value({ 'SecurityLabelNested' => true }) }
  it { is_expected.to allow_value({ 'SecurityLabelType' => 'spc_t' }) }
  it { is_expected.to allow_value({ 'ShmSize' => '100m' }) }
  it { is_expected.to allow_value({ 'StartWithPod' => true }) }
  it { is_expected.to allow_value({ 'StopSignal' => 'SIGTERM' }) }
  it { is_expected.to allow_value({ 'StopTimeout' => 10 }) }
  it { is_expected.to allow_value({ 'SubGIDMap' => 'gtest' }) }
  it { is_expected.to allow_value({ 'SubUIDMap' => 'utest' }) }
  it { is_expected.to allow_value({ 'Sysctl' => 'net.ipv4.ip_forward=1' }) }
  it { is_expected.to allow_value({ 'Sysctl' => ['net.ipv4.ip_forward=1', 'net.core.somaxconn=1024'] }) }
  it { is_expected.to allow_value({ 'Timezone' => 'America/New_York' }) }
  it { is_expected.to allow_value({ 'Tmpfs' => '/run:rw,size=64m' }) }
  it { is_expected.to allow_value({ 'Tmpfs' => ['/run:rw,size=64m', '/tmp:ro'] }) }
  it { is_expected.to allow_value({ 'UIDMap' => '0:100000:65536' }) }
  it { is_expected.to allow_value({ 'UIDMap' => ['0:100000:65536', '65536:200000:65536'] }) }
  it { is_expected.to allow_value({ 'Ulimit' => 'nofile=1024:1024' }) }
  it { is_expected.to allow_value({ 'Unmask' => '/proc/sys/foo' }) }
  it { is_expected.to allow_value({ 'User' => 'appuser' }) }
  it { is_expected.to allow_value({ 'User' => 1000 }) }
  it { is_expected.to allow_value({ 'UserNS' => 'auto' }) }
  it { is_expected.to allow_value({ 'Volume' => '/data:/mnt/data:Z' }) }
  it { is_expected.to allow_value({ 'Volume' => ['/data:/mnt/data:Z', '/etc/ssl:/ssl:ro'] }) }
  it { is_expected.to allow_value({ 'WorkingDir' => '/opt/myapp' }) }
end
