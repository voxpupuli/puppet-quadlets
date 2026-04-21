# frozen_string_literal: true

require 'spec_helper'

describe 'Quadlets::Unit::Pod' do
  it { is_expected.to allow_value({ 'AddHost' => 'db.internal:192.168.20.10' }) }
  it { is_expected.to allow_value({ 'AddHost' => ['db.internal:192.168.20.10', 'redis.internal:192.168.20.11'] }) }
  it { is_expected.to allow_value({ 'ContainersConfModule' => '/etc/container/1.conf' }) }
  it { is_expected.to allow_value({ 'ContainersConfModule' => ['/etc/container/1.conf', '/etc/container/2.conf'] }) }
  it { is_expected.to allow_value({ 'DNS' => '192.168.1.1' }) }
  it { is_expected.to allow_value({ 'DNS' => ['192.168.1.1', '10.0.0.53'] }) }
  it { is_expected.to allow_value({ 'DNSOption' => 'ndots:1' }) }
  it { is_expected.to allow_value({ 'DNSOption' => ['ndots:1', 'timeout:2'] }) }
  it { is_expected.to allow_value({ 'DNSSearch' => 'example.com' }) }
  it { is_expected.to allow_value({ 'DNSSearch' => ['example.com', 'svc.cluster.local'] }) }
  it { is_expected.not_to allow_value({ 'ExitPolicy' => 'random' }) }
  it { is_expected.to allow_value({ 'ExitPolicy' => 'continue' }) }
  it { is_expected.to allow_value({ 'ExitPolicy' => 'stop' }) }
  it { is_expected.to allow_value({ 'GIDMap' => '0:10000:10' }) }
  it { is_expected.to allow_value({ 'GIDMap' => ['0:10000:10', '10:20000:10'] }) }
  it { is_expected.to allow_value({ 'GlobalArgs' => '--log-level=debug' }) }
  it { is_expected.to allow_value({ 'GlobalArgs' => ['--log-level=debug', '--cgroup-manager=systemd'] }) }
  it { is_expected.to allow_value({ 'HostName' => 'foo.example.net' }) }
  it { is_expected.to allow_value({ 'HostName' => ['foo.example.net'] }) }
  it { is_expected.to allow_value({ 'IP' => '192.168.1.5' }) }
  it { is_expected.not_to allow_value({ 'IP' => '2001:db8::1' }) }
  it { is_expected.to allow_value({ 'IP6' => '2001:db8::1' }) }
  it { is_expected.not_to allow_value({ 'IP6' => '192.168.1.5' }) }
  it { is_expected.to allow_value({ 'Label' => %w[abc xyz] }) }
  it { is_expected.to allow_value({ 'Label' => 'xyz' }) }
  it { is_expected.to allow_value({ 'Network' => 'host' }) }
  it { is_expected.to allow_value({ 'Network' => ['mynet', 'mynet2'] }) }
  it { is_expected.to allow_value({ 'NetworkAlias' => 'mypod' }) }
  it { is_expected.to allow_value({ 'NetworkAlias' => ['mypod', 'mypod-alias'] }) }
  it { is_expected.to allow_value({ 'PodmanArgs' => '--exit-policy=continue' }) }
  it { is_expected.to allow_value({ 'PodmanArgs' => ['--exit-policy=continue', '--log-level=debug'] }) }
  it { is_expected.to allow_value({ 'PodName' => 'special' }) }
  it { is_expected.to allow_value({ 'PublishPort' => ['1234:5678'] }) }
  it { is_expected.not_to allow_value({ 'PublishPort' => '1234:5678' }) }
  it { is_expected.to allow_value({ 'ServiceName' => 'my-pod' }) }
  it { is_expected.to allow_value({ 'ShmSize' => '64m' }) }
  it { is_expected.to allow_value({ 'StopTimeout' => 30 }) }
  it { is_expected.to allow_value({ 'SubGIDMap' => 'gtest' }) }
  it { is_expected.to allow_value({ 'SubUIDMap' => 'utest' }) }
  it { is_expected.to allow_value({ 'UIDMap' => '0:100000:65536' }) }
  it { is_expected.to allow_value({ 'UIDMap' => ['0:100000:65536', '65536:200000:65536'] }) }
  it { is_expected.to allow_value({ 'UserNS' => 'auto' }) }
  it { is_expected.to allow_value({ 'Volume' => '/data:/mnt/data:Z' }) }
  it { is_expected.to allow_value({ 'Volume' => ['/data:/mnt/data:Z', '/etc/ssl:/ssl:ro'] }) }
end
