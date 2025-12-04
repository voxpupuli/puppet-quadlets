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
  it { is_expected.to allow_value({ 'ContainersConfModule' => ['log_driver=journald', 'runtime=crun'] }) }
  it { is_expected.to allow_value({ 'ContainersConfModule' => 'pids_limit=2048' }) }
  it { is_expected.to allow_value({ 'DNSSearch' => 'example.com' }) }
  it { is_expected.to allow_value({ 'DNSSearch' => ['example.com', 'svc.cluster.local'] }) }
  it { is_expected.to allow_value({ 'DropCapability' => 'CAP_NET_RAW' }) }
  it { is_expected.to allow_value({ 'DropCapability' => %w[CAP_NET_RAW CAP_SYS_ADMIN] }) }
  it { is_expected.to allow_value({ 'Entrypoint' => 'python3' }) }
  it { is_expected.to allow_value({ 'Entrypoint' => '["/usr/bin/sleep", "inf"]' }) }
  it { is_expected.to allow_value({ 'Environment' => 'FOO=bar' }) }
  it { is_expected.to allow_value({ 'Environment' => ['FOO=bar', 'BAZ=qux'] }) }
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
  it { is_expected.to allow_value({ 'HealthRetries' => 1 }) }
  it { is_expected.to allow_value({ 'HealthStartPeriod' => 10 }) }
  it { is_expected.to allow_value({ 'HealthStartupCmd' => '["/usr/bin/checkme --verywell","/bin/can-be-json-string-also-allow"]' }) }
  it { is_expected.to allow_value({ 'HealthStartupInterval' => 30 }) }
  it { is_expected.to allow_value({ 'HealthStartupTimeout' => 1 }) }
  it { is_expected.to allow_value({ 'HealthTimeout' => '2m' }) }
  it { is_expected.to allow_value({ 'HostName' => 'foo.example.net' }) }
  it { is_expected.to allow_value({ 'HostName' => ['foo.example.net'] }) }
  it { is_expected.to allow_value({ 'Image' => 'busybox' }) }
  it { is_expected.to allow_value({ 'Mount' => '/data:/mnt/data:rw' }) }
  it { is_expected.to allow_value({ 'Mount' => ['/data:/mnt/data:rw', '/etc/ssl:/ssl:ro'] }) }
  it { is_expected.to allow_value({ 'NetworkAlias' => 'webapp' }) }
  it { is_expected.to allow_value({ 'NetworkAlias' => %w[webapp api backend] }) }
  it { is_expected.not_to allow_value({ 'Pod' => 'foo' }) }
  it { is_expected.to allow_value({ 'Pod' => 'foo1234.pod' }) }
  it { is_expected.to allow_value({ 'Pod' => 'foo-bar.pod' }) }
  it { is_expected.to allow_value({ 'Pod' => 'foo_bar.pod' }) }
  it { is_expected.to allow_value({ 'PublishPort' => [1234] }) }
  it { is_expected.to allow_value({ 'PublishPort' => [1234, '123.111.1.1:55:72'] }) }
  it { is_expected.to allow_value({ 'PublishPort' => ['1234-12346'] }) }
  it { is_expected.to allow_value({ 'PublishPort' => '1234:5678' }) }
  it { is_expected.to allow_value({ 'PublishPort' => ['1234:5678'] }) }
  it { is_expected.to allow_value({ 'Secret' => ['db_password:ro', 'api_key:rw'] }) }
  it { is_expected.to allow_value({ 'Secret' => 'mysecret:ro' }) }
  it { is_expected.to allow_value({ 'Sysctl' => 'net.ipv4.ip_forward=1' }) }
  it { is_expected.to allow_value({ 'Sysctl' => ['net.ipv4.ip_forward=1', 'net.core.somaxconn=1024'] }) }
  it { is_expected.to allow_value({ 'Tmpfs' => '/run:rw,size=64m' }) }
  it { is_expected.to allow_value({ 'Tmpfs' => ['/run:rw,size=64m', '/tmp:ro'] }) }
  it { is_expected.to allow_value({ 'UIDMap' => '0:100000:65536' }) }
  it { is_expected.to allow_value({ 'UIDMap' => ['0:100000:65536', '65536:200000:65536'] }) }
  it { is_expected.to allow_value({ 'Volume' => '/data:/mnt/data:Z' }) }
  it { is_expected.to allow_value({ 'Volume' => ['/data:/mnt/data:Z', '/etc/ssl:/ssl:ro'] }) }
end
