# frozen_string_literal: true

require 'spec_helper'

describe 'Quadlets::Unit::Pod' do
  it { is_expected.to allow_value({ 'PodName' => 'special' }) }
  it { is_expected.to allow_value({ 'PublishPort' => ['1234:5678'] }) }
  it { is_expected.not_to allow_value({ 'PublishPort' => '1234:5678' }) }
end
