# frozen_string_literal: true

require 'spec_helper'

describe 'Quadlets::Unit::Image' do
  it { is_expected.to allow_value({ 'AllTags' => true }) }
  it { is_expected.to allow_value({ 'Arch' => 'aarch64' }) }
  it { is_expected.to allow_value({ 'AuthFile' => '/etc/registry/auth.json' }) }
  it { is_expected.to allow_value({ 'CertDir' => '/etc/registry/certs' }) }
  it { is_expected.to allow_value({ 'ContainersConfModule' => ['/etc/nvd.conf'] }) }
  it { is_expected.to allow_value({ 'Creds' => 'myname:mypassword' }) }
  it { is_expected.to allow_value({ 'DecryptionKey' => '/etc/registry.key' }) }
  it { is_expected.to allow_value({ 'GlobalArgs' => ['--log-level=debug'] }) }
  it { is_expected.to allow_value({ 'Image' => 'quay.io/centos/centos:latest' }) }
  it { is_expected.to allow_value({ 'ImageTag' => 'quay.io/centos/centos:latest' }) }
  it { is_expected.to allow_value({ 'OS' => 'windows' }) }
  it { is_expected.to allow_value({ 'PodmanArgs' => ['--os=linux'] }) }
  it { is_expected.to allow_value({ 'Policy' => 'always' }) }
  it { is_expected.to allow_value({ 'Retry' => 5 }) }
  it { is_expected.to allow_value({ 'RetryDelay' => '10s' }) }
  it { is_expected.to allow_value({ 'TLSVerify' => false }) }
  it { is_expected.to allow_value({ 'Variant' => 'arm/v7' }) }
end
