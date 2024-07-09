# frozen_string_literal: true

require 'spec_helper'

describe 'Quadlets::Unit::Pod' do
  it { is_expected.to allow_value({ 'PodName' => 'special' }) }
end
