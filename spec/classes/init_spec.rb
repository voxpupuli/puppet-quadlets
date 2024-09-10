# frozen_string_literal: true

require 'spec_helper'

describe 'quadlets' do
  context 'supported operating systems' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) { os_facts }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to create_class('quadlets') }
        it { is_expected.to contain_class('quadlets::install') }
        it { is_expected.to contain_package('podman').with_ensure('installed') }
        it { is_expected.to contain_service('podman.socket').with_ensure(true).with_enable(true) }

        case os_facts['os']['family']
        when 'Archlinux'
          it { is_expected.to contain_file('/etc/containers/systemd').with_ensure('directory') }
        else
          it { is_expected.not_to contain_file('/etc/containers/systemd') }
        end

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
