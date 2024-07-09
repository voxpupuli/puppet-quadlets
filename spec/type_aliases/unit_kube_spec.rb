# frozen_string_literal: true

require 'spec_helper'

describe 'Quadlets::Unit::Kube' do
  it { is_expected.to allow_value({ 'Yaml' => '/path/to/yaml/file' }) }
  it { is_expected.to allow_value({ 'PublishPort' => ['1234-12346'] }) }
  it { is_expected.to allow_value({ 'PublishPort' => [1234, '123.111.1.1:23:56'] }) }
  it { is_expected.to allow_value({ 'ConfigMap' => ['/path/to/configmap.yaml'] }) }
  it { is_expected.to allow_value({ 'Network' => ['host'] }) }
  it { is_expected.to allow_value({ 'KubeDownForce' => true }) }
  it { is_expected.to allow_value({ 'ExitCodePropagation' => 'any' }) }
end
