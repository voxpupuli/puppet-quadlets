# frozen_string_literal: true

require 'spec_helper'

describe 'Quadlets::Auth' do
  context 'with a permitted unit name' do
    [
      { username: 'test', password: '***secret***' }
    ].each do |unit|
      it { is_expected.to allow_value(unit) }
    end
  end

  context 'with a illegal unit name' do
    [
      { username: 'test' },
    ].each do |unit|
      it { is_expected.not_to allow_value(unit) }
    end
  end
end
