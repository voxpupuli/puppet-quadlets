# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'quadlets' do
  context 'with default values' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
      include quadlets
        PUPPET
      end
    end

    describe package('podman') do
      it { is_expected.to be_installed }
    end

    describe service('podman.socket') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end
  end

  context 'with socket disabled' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
      class{ 'quadlets':
        socket_enable => false,
      }
        PUPPET
      end
    end

    describe package('podman') do
      it { is_expected.to be_installed }
    end

    describe service('podman.socket') do
      it { is_expected.not_to be_running }
      it { is_expected.not_to be_enabled }
    end
  end
end
