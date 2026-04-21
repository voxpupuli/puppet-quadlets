# frozen_string_literal: true

require 'spec_helper'

describe 'Quadlets::Unit::Network' do
  it { is_expected.to allow_value({ 'ContainersConfModule' => '/etc/container/1.conf' }) }
  it { is_expected.to allow_value({ 'ContainersConfModule' => ['/etc/container/1.conf', '/etc/container/2.conf'] }) }
  it { is_expected.to allow_value({ 'DisableDNS'           => true }) }
  it { is_expected.to allow_value({ 'DisableDNS'           => false }) }
  it { is_expected.to allow_value({ 'DNS'                  => '192.0.2.1' }) }
  it { is_expected.to allow_value({ 'Driver'               => 'bridge' }) }
  it { is_expected.to allow_value({ 'Driver'               => 'macvlan' }) }
  it { is_expected.to allow_value({ 'Gateway'              => '192.0.2.2' }) }
  it { is_expected.to allow_value({ 'GlobalArgs'           => '--log-level=debug' }) }
  it { is_expected.to allow_value({ 'GlobalArgs'           => ['--log-level=debug', '--cgroup-manager=systemd'] }) }
  it { is_expected.to allow_value({ 'Internal'             => true }) }
  it { is_expected.to allow_value({ 'IPAMDriver'           => 'dhcp' }) }
  it { is_expected.to allow_value({ 'IPAMDriver'           => 'host-local' }) }
  it { is_expected.to allow_value({ 'IPRange'              => '192.0.2.0/25' }) }
  it { is_expected.to allow_value({ 'IPv6'                 => true }) }
  it { is_expected.to allow_value({ 'Label'                => 'XYZ' }) }
  it { is_expected.to allow_value({ 'Label'                => %w[XYZ ABC] }) }
  it { is_expected.to allow_value({ 'NetworkDeleteOnStop'  => true }) }
  it { is_expected.to allow_value({ 'NetworkName'          => 'foo' }) }
  it { is_expected.to allow_value({ 'Options'              => 'isolate=true' }) }
  it { is_expected.to allow_value({ 'PodmanArgs'           => '--dns=192.0.2.1' }) }
  it { is_expected.to allow_value({ 'PodmanArgs'           => ['--dns=192.0.2.1', '--log-level=debug'] }) }
  it { is_expected.to allow_value({ 'Subnet'               => '192.0.2.0/24' }) }
end
