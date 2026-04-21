# frozen_string_literal: true

require 'spec_helper'

describe 'Quadlets::Unit::Build' do
  it { is_expected.to allow_value({ 'Annotation' => 'annotation=value' }) }
  it { is_expected.to allow_value({ 'Annotation' => ['annotation=value', 'another=value'] }) }
  it { is_expected.to allow_value({ 'Arch' => 'aarch64' }) }
  it { is_expected.to allow_value({ 'AuthFile' => '/etc/registry/auth.json' }) }
  it { is_expected.to allow_value({ 'BuildArg' => 'VERSION=1.0' }) }
  it { is_expected.to allow_value({ 'BuildArg' => ['VERSION=1.0', 'DEBUG=false'] }) }
  it { is_expected.to allow_value({ 'ContainersConfModule' => '/etc/nvd.conf' }) }
  it { is_expected.to allow_value({ 'ContainersConfModule' => ['/etc/nvd.conf', '/etc/extra.conf'] }) }
  it { is_expected.to allow_value({ 'DNS' => '192.168.55.1' }) }
  it { is_expected.to allow_value({ 'DNS' => ['192.168.55.1', '10.0.0.53'] }) }
  it { is_expected.to allow_value({ 'DNSOption' => 'ndots:1' }) }
  it { is_expected.to allow_value({ 'DNSOption' => ['ndots:1', 'timeout:2'] }) }
  it { is_expected.to allow_value({ 'DNSSearch' => 'example.com' }) }
  it { is_expected.to allow_value({ 'DNSSearch' => ['example.com', 'svc.cluster.local'] }) }
  it { is_expected.to allow_value({ 'Environment' => 'foo=bar' }) }
  it { is_expected.to allow_value({ 'Environment' => ['foo=bar', 'baz=qux'] }) }
  it { is_expected.to allow_value({ 'File' => '/path/to/Containerfile' }) }
  it { is_expected.to allow_value({ 'File' => 'https://example.com/Containerfile' }) }
  it { is_expected.to allow_value({ 'ForceRM' => true }) }
  it { is_expected.to allow_value({ 'ForceRM' => false }) }
  it { is_expected.to allow_value({ 'GlobalArgs' => '--log-level=debug' }) }
  it { is_expected.to allow_value({ 'GlobalArgs' => ['--log-level=debug', '--cgroup-manager=systemd'] }) }
  it { is_expected.to allow_value({ 'GroupAdd' => 'keep-groups' }) }
  it { is_expected.to allow_value({ 'GroupAdd' => ['wheel', 'keep-groups'] }) }
  it { is_expected.to allow_value({ 'IgnoreFile' => '/path/to/.customignore' }) }
  it { is_expected.to allow_value({ 'ImageTag' => 'localhost/imagename' }) }
  it { is_expected.to allow_value({ 'ImageTag' => ['localhost/imagename', 'localhost/imagename:latest'] }) }
  it { is_expected.to allow_value({ 'Label' => 'label=value' }) }
  it { is_expected.to allow_value({ 'Label' => ['label=value', 'another=value'] }) }
  it { is_expected.to allow_value({ 'Network' => 'host' }) }
  it { is_expected.to allow_value({ 'Network' => ['host'] }) }
  it { is_expected.to allow_value({ 'PodmanArgs' => '--pull never' }) }
  it { is_expected.to allow_value({ 'PodmanArgs' => ['--pull never', '--log-level=debug'] }) }
  it { is_expected.not_to allow_value({ 'Pull' => 'random' }) }
  it { is_expected.to allow_value({ 'Pull' => 'always' }) }
  it { is_expected.to allow_value({ 'Pull' => 'missing' }) }
  it { is_expected.to allow_value({ 'Pull' => 'never' }) }
  it { is_expected.to allow_value({ 'Pull' => 'newer' }) }
  it { is_expected.to allow_value({ 'Retry' => 5 }) }
  it { is_expected.to allow_value({ 'RetryDelay' => '10s' }) }
  it { is_expected.to allow_value({ 'Secret' => 'mysecret' }) }
  it { is_expected.to allow_value({ 'Secret' => ['mysecret', 'id=other,src=/path'] }) }
  it { is_expected.to allow_value({ 'SetWorkingDirectory' => 'unit' }) }
  it { is_expected.to allow_value({ 'SetWorkingDirectory' => 'file' }) }
  it { is_expected.to allow_value({ 'SetWorkingDirectory' => '/path/to/context' }) }
  it { is_expected.to allow_value({ 'Target' => 'my-app' }) }
  it { is_expected.to allow_value({ 'TLSVerify' => true }) }
  it { is_expected.to allow_value({ 'TLSVerify' => false }) }
  it { is_expected.to allow_value({ 'Variant' => 'arm/v7' }) }
  it { is_expected.to allow_value({ 'Volume' => '/source:/dest' }) }
  it { is_expected.to allow_value({ 'Volume' => ['/source:/dest', '/cache:/cache:ro'] }) }
end
