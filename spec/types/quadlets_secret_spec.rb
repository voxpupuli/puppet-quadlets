# frozen_string_literal: true

require 'spec_helper'

describe 'quadlets_secret' do
  let(:title) { 'root:asecret' }

  context 'with default provider' do
    it { is_expected.to be_valid_type.with_properties('ensure') }
    it { is_expected.to be_valid_type.with_parameters('driver') }
    it { is_expected.to be_valid_type.with_parameters('doptions') }
    it { is_expected.to be_valid_type.with_properties('labels') }
    it { is_expected.to be_valid_type.with_properties('secret') }
  end
end
