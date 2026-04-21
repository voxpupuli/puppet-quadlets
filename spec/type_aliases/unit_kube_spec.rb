# frozen_string_literal: true

require 'spec_helper'

describe 'Quadlets::Unit::Kube' do
  it { is_expected.to allow_value({ 'AutoUpdate' => 'registry' }) }
  it { is_expected.to allow_value({ 'AutoUpdate' => %w[registry image] }) }
  it { is_expected.to allow_value({ 'ConfigMap' => '/path/to/configmap.yaml' }) }
  it { is_expected.to allow_value({ 'ConfigMap' => ['/path/to/configmap.yaml'] }) }
  it { is_expected.to allow_value({ 'ContainersConfModule' => '/etc/nvd.conf' }) }
  it { is_expected.to allow_value({ 'ContainersConfModule' => ['/etc/nvd.conf', '/etc/extra.conf'] }) }
  it { is_expected.not_to allow_value({ 'ExitCodePropagation' => 'random' }) }
  it { is_expected.to allow_value({ 'ExitCodePropagation' => 'all' }) }
  it { is_expected.to allow_value({ 'ExitCodePropagation' => 'any' }) }
  it { is_expected.to allow_value({ 'ExitCodePropagation' => 'none' }) }
  it { is_expected.to allow_value({ 'GlobalArgs' => '--log-level=info' }) }
  it { is_expected.to allow_value({ 'GlobalArgs' => ['--log-level=info', '--cgroup-manager=systemd'] }) }
  it { is_expected.to allow_value({ 'KubeDownForce' => true }) }
  it { is_expected.to allow_value({ 'LogDriver' => 'journald' }) }
  it { is_expected.to allow_value({ 'Network' => 'host' }) }
  it { is_expected.to allow_value({ 'Network' => ['host'] }) }
  it { is_expected.to allow_value({ 'PodmanArgs' => '--pull=newer' }) }
  it { is_expected.to allow_value({ 'PodmanArgs' => ['--pull=newer', '--log-level=debug'] }) }
  it { is_expected.to allow_value({ 'PublishPort' => [1234, '123.111.1.1:23:56'] }) }
  it { is_expected.to allow_value({ 'PublishPort' => ['1234-12346'] }) }
  it { is_expected.to allow_value({ 'PublishPort' => '1234:5678' }) }
  it { is_expected.to allow_value({ 'PublishPort' => ['1234:5678'] }) }
  it { is_expected.not_to allow_value({ 'SetWorkingDirectory' => 'random' }) }
  it { is_expected.to allow_value({ 'SetWorkingDirectory' => 'yaml' }) }
  it { is_expected.to allow_value({ 'SetWorkingDirectory' => 'unit' }) }
  it { is_expected.to allow_value({ 'UserNS' => 'auto' }) }
  it { is_expected.to allow_value({ 'Yaml' => '/path/to/yaml/file' }) }
end
