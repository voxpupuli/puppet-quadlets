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

        context 'with manage service enabled and socket enabled' do
          let(:params) do
            { manage_service: true, socket_enable: true }
          end

          it { is_expected.to contain_service('podman.socket').with_ensure(true).with_enable(true) }
        end

        context 'with manage service disabled' do
          let(:params) do
            { manage_service: false }
          end

          it { is_expected.not_to contain_service('podman.socket') }
        end

        context 'with manage service enabled, socket disabled' do
          let(:params) do
            { manage_service: true, socket_enable: false }
          end

          it { is_expected.to contain_service('podman.socket').with_ensure(false).with_enable(false) }
        end

        context 'with purge_quadlet_dir param' do
          context 'with true' do
            let(:params) do
              { create_quadlet_dir: true, purge_quadlet_dir: true }
            end

            it do
              is_expected.to contain_file('/etc/containers/systemd').with(
                purge: true,
                force: true,
                recurse: true
              )
            end
          end

          context 'with false' do
            let(:params) do
              { create_quadlet_dir: true, purge_quadlet_dir: false }
            end

            it do
              is_expected.to contain_file('/etc/containers/systemd').with(
                purge: false,
                force: false,
                recurse: false
              )
            end
          end
        end
      end
    end
  end
end
