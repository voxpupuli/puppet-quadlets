# frozen_string_literal: true

require 'spec_helper'

describe 'Quadlets::Unit::Container' do
  it { is_expected.to allow_value({ 'Image' => 'busybox' }) }
  it { is_expected.to allow_value({ 'PublishPort' => [1234] }) }
  it { is_expected.to allow_value({ 'PublishPort' => ['1234-12346'] }) }
  it { is_expected.to allow_value({ 'PublishPort' => [1234, '123.111.1.1:55:72'] }) }
  it { is_expected.to allow_value({ 'PublishPort' => ['1234:5678'] }) }
  it { is_expected.to allow_value({ 'PublishPort' => '1234:5678' }) }
  it { is_expected.to allow_value({ 'Entrypoint' => 'python3' }) }
  it { is_expected.to allow_value({ 'Entrypoint' => '["/usr/bin/sleep", "inf"]' }) }
  it { is_expected.to allow_value({ 'Exec'  => '/bin/bash' }) }
  it { is_expected.to allow_value({ 'Exec'  => './entrypoint.sh' }) }
  it { is_expected.to allow_value({ 'HostName' => ['foo.example.net'] }) }
  it { is_expected.to allow_value({ 'HostName' => 'foo.example.net' }) }
  it { is_expected.to allow_value({ 'Pod' => 'foo1234.pod' }) }
  it { is_expected.to allow_value({ 'Pod' => 'foo-bar.pod' }) }
  it { is_expected.to allow_value({ 'Pod' => 'foo_bar.pod' }) }
  it { is_expected.not_to allow_value({ 'Pod' => 'foo' }) }
  it { is_expected.to allow_value({ 'HealthCmd' => '/usr/bin/checkme --verywell' }) }
  it { is_expected.to allow_value({ 'HealthCmd' => '["/usr/bin/checkme --verywell","/bin/can-be-json-string-also-allow"]' }) }
  it { is_expected.to allow_value({ 'HealthInterval' => 30 }) }
  it { is_expected.to allow_value({ 'HealthInterval' => 'disable' }) }
  it { is_expected.to allow_value({ 'HealthOnFailure' => 'none' }) }
  it { is_expected.not_to allow_value({ 'HealthOnFailure' => 'random-string' }) }
  it { is_expected.to allow_value({ 'HealthStartPeriod' => 10 }) }
  it { is_expected.to allow_value({ 'HealthStartupCmd' => '["/usr/bin/checkme --verywell","/bin/can-be-json-string-also-allow"]' }) }
  it { is_expected.to allow_value({ 'HealthStartupInterval' => 30 }) }
  it { is_expected.to allow_value({ 'HealthStartupTimeout' => 1 }) }
  it { is_expected.to allow_value({ 'HealthTimeout' => '2m' }) }
  it { is_expected.to allow_value({ 'HealthRetries' => 1 }) }
  it { is_expected.to allow_value({ 'HealthMaxLogCount' => 10 }) }
  it { is_expected.to allow_value({ 'HealthMaxLogSize' => 3000 }) }
  it { is_expected.to allow_value({ 'HealthLogDestination' => '/var/log/health.log' }) }
  it { is_expected.to allow_value({ 'HealthLogDestination' => 'local' }) }
  it { is_expected.to allow_value({ 'HealthLogDestination' => 'events_logger' }) }
  it { is_expected.not_to allow_value({ 'HealthLogDestination' => 'random-string' }) }
end
