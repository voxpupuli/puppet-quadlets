# frozen_string_literal: true

require 'spec_helper'

describe 'quadlets' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to create_class('quadlets') }
        it { is_expected.to contain_class('quadlets::install') }
        it { is_expected.to contain_package('podman').with_ensure('installed') }
        it { is_expected.to contain_service('podman.socket').with_ensure(true).with_enable(true) }

        context 'with service enabled' do
          let(:params) do
            { socket_enable: true }
          end

          it { is_expected.to contain_service('podman.socket').with_ensure(true).with_enable(true) }
        end

        context 'with service disabled' do
          let(:params) do
            { socket_enable: false }
          end

          it { is_expected.to contain_service('podman.socket').with_ensure(false).with_enable(false) }
        end
      end
    end
  end
end
