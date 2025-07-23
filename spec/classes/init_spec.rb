# frozen_string_literal: true

require 'spec_helper'

describe 'quadlets' do
  context 'supported operating systems' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) { os_facts }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to create_class('quadlets') }
        it { is_expected.to contain_service('podman.socket').with_ensure(true).with_enable(true) }
        it { is_expected.not_to contain_service('podman-auto-update.timer') }

        case os_facts['os']['family']
        when 'Archlinux'
          it { is_expected.to contain_file('/etc/containers/systemd').with_ensure('directory') }
        else
          it { is_expected.not_to contain_file('/etc/containers/systemd') }
        end

        context 'with manage_package enabled' do
          let(:params) do
            { manage_package: true }
          end

          it { is_expected.to contain_class('quadlets::install') }
          it { is_expected.to contain_package('podman').with_ensure('installed') }
        end

        context 'with manage_package enabled, package_ensure latest, and package_names=test,test2' do
          let(:params) do
            { manage_package: true, package_ensure: 'latest', package_names: %w[test test2] }
          end

          it { is_expected.to contain_class('quadlets::install') }
          it { is_expected.not_to contain_package('podman') }
          it { is_expected.to contain_package('test').with_ensure('latest') }
          it { is_expected.to contain_package('test2').with_ensure('latest') }
        end

        context 'with manage_package disabled' do
          let(:params) do
            { manage_package: false }
          end

          it { is_expected.to contain_class('quadlets::install') }
          it { is_expected.not_to contain_package('podman').with_ensure('installed') }
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

        context 'with manage update timer enabled and timer enabled' do
          let(:params) do
            { manage_autoupdate_timer: true, autoupdate_timer_enable: true }
          end

          it { is_expected.to contain_service('podman-auto-update.timer').with_ensure('running').with_enable(true) }
        end

        context 'with manage update timer enabled, timer enabled, and a custom name' do
          let(:params) do
            { manage_autoupdate_timer: true, autoupdate_timer_ensure: 'stopped', autoupdate_timer_enable: true, autoupdate_timer_name: 'test.unit' }
          end

          it { is_expected.to contain_service('test.unit').with_ensure('stopped').with_enable(true) }
        end

        context 'with manage update timer disabled' do
          let(:params) do
            { manage_autoupdate_timer: false }
          end

          it { is_expected.not_to contain_service('podman-auto-update.timer') }
        end

        context 'with manage update timer enabled, update timer disabled' do
          let(:params) do
            { manage_autoupdate_timer: true, autoupdate_timer_enable: false }
          end

          it { is_expected.to contain_service('podman-auto-update.timer').with_enable(false) }
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
