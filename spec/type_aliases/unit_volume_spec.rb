# frozen_string_literal: true

require 'spec_helper'

describe 'Quadlets::Unit::Volume' do
  it { is_expected.to allow_value({ 'ContainersConfModule' => '/etc/nvd.conf' }) }
  it { is_expected.to allow_value({ 'ContainersConfModule' => ['/etc/nvd.conf', '/etc/extra.conf'] }) }
  it { is_expected.to allow_value({ 'Copy'    => true }) }
  it { is_expected.to allow_value({ 'Copy'    => false }) }
  it { is_expected.to allow_value({ 'Device'  => '/dev/sdb1' }) }
  it { is_expected.to allow_value({ 'Driver'  => 'image' }) }
  it { is_expected.to allow_value({ 'Driver'  => 'local' }) }
  it { is_expected.to allow_value({ 'GlobalArgs' => '--log-level=debug' }) }
  it { is_expected.to allow_value({ 'GlobalArgs' => ['--log-level=debug', '--cgroup-manager=systemd'] }) }
  it { is_expected.to allow_value({ 'Group'   => 'appgroup' }) }
  it { is_expected.to allow_value({ 'Image'   => 'quay.io/centos/centos:latest' }) }
  it { is_expected.to allow_value({ 'Label'   => 'org.example.key=value' }) }
  it { is_expected.to allow_value({ 'Label'   => ['org.example.key=value', 'version=1.0'] }) }
  it { is_expected.to allow_value({ 'Options' => 'uid=1000,gid=1000' }) }
  it { is_expected.to allow_value({ 'PodmanArgs' => '--driver=local' }) }
  it { is_expected.to allow_value({ 'PodmanArgs' => ['--driver=local', '--log-level=debug'] }) }
  it { is_expected.to allow_value({ 'Type'    => 'tmpfs' }) }
  it { is_expected.to allow_value({ 'Type'    => 'fuse.s3fs' }) }
  it { is_expected.to allow_value({ 'User'    => 'appuser' }) }
  it { is_expected.to allow_value({ 'VolumeName' => 'my-data-volume' }) }
end
