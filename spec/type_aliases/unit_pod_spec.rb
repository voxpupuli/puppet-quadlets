# frozen_string_literal: true

require 'spec_helper'

describe 'Quadlets::Unit::Pod' do
  it { is_expected.to allow_value({ 'PodName' => 'special' }) }
  it { is_expected.to allow_value({ 'Hostname' => ['foo.example.net'] }) }
  it { is_expected.to allow_value({ 'Hostname' => 'foo.example.net' }) }
  it { is_expected.to allow_value({ 'Label' => %w[abc xyz] }) }
  it { is_expected.to allow_value({ 'Label' => 'xyz' }) }
end
