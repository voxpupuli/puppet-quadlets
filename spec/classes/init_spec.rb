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
        it { is_expected.to contain_class('quadlets::config') }
        it { is_expected.to contain_class('quadlets::service') }
        it { is_expected.to contain_service('podman.socket').with_ensure(true).with_enable(true) }
        it { is_expected.not_to contain_service('podman-auto-update.timer') }

        case os_facts['os']['family']
        when 'Archlinux'
          it { is_expected.to contain_file('/etc/containers/systemd').with_ensure('directory') }
        else
          it { is_expected.not_to contain_file('/etc/containers/systemd') }
        end

        case os_facts['os']['family']
        when 'Archlinux', 'RedHat'
          it { is_expected.to contain_file('/etc/containers/systemd/users').with_ensure('directory') }
        else
          it { is_expected.not_to contain_file('/etc/containers/systemd/users') }
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
          let(:params) do
            {
              create_quadlet_dir: true,
              create_quadlet_users_dir: true,
            }
          end

          context 'with true' do
            let(:params) do
              super().merge(purge_quadlet_dir: true)
            end

            it do
              is_expected.to contain_file('/etc/containers/systemd').with(
                purge: true,
                force: true,
                recurse: true,
              )
            end

            it do
              is_expected.to contain_file('/etc/containers/systemd/users').with(
                purge: true,
                force: true,
                recurse: true,
              )
            end
          end

          context 'with false' do
            let(:params) do
              super().merge(purge_quadlet_dir: false)
            end

            it do
              is_expected.to contain_file('/etc/containers/systemd').with(
                purge: false,
                force: false,
                recurse: false,
              )
            end

            it do
              is_expected.to contain_file('/etc/containers/systemd/users').with(
                purge: false,
                force: false,
                recurse: false,
              )
            end
          end
        end

        context 'with quadlets_hash param' do
          context 'with quadlets_hash as default' do
            it { is_expected.to have_quadlets__quadlet_resource_count(0) }
          end

          context 'with quadlets_hash defined' do
            let(:params) do
              { quadlets_hash: {
                'centos.container': {
                  'ensure' => 'present',
                  'unit_entry' => {
                    'Description' => 'Trivial Container that will be very lazy',
                  },
                  'service_entry' => {
                    'TimeoutStartSec' => '900',
                  },
                  'container_entry' => {
                    'Image' => 'quay.io/centos/centos:latest',
                    'Exec' => 'sh -c "sleep inf"',
                  },
                  'install_entry' => {
                    'WantedBy' => 'default.target',
                  },
                  'active' => true,
                },
                'almalinux.container': {
                  'ensure' => 'present',
                  'unit_entry' => {
                    'Description' => 'Second Trivial Container',
                  },
                  'service_entry' => {
                    'TimeoutStartSec' => '900',
                  },
                  'container_entry' => {
                    'Image' => 'quay.io/almalinux/almalinux:latest',
                    'Exec' => 'sh -c "sleep inf"',
                  },
                  'install_entry' => {
                    'WantedBy' => 'default.target',
                  },
                  'active' => false,
                },
              } }
            end

            it { is_expected.to have_quadlets__quadlet_resource_count(2) }
            it { is_expected.to contain_quadlets__quadlet('almalinux.container').with_ensure('present') }

            it {
              is_expected.to contain_file('/etc/containers/systemd/almalinux.container')
                .with_ensure('present')
                .with_content(%r{^Description=Second Trivial Container$})
                .with_content(%r{^Image=quay.io/almalinux/almalinux:latest$})
            }

            it { is_expected.to contain_systemd__daemon_reload('almalinux.container') }
            # active is false for almalinux.container
            it { is_expected.to contain_service('almalinux.service').with_ensure(false) }
          end
        end

        context 'with users_hash as default' do
          it { is_expected.to have_quadlets__user_resource_count(0) }
        end

        context 'with quadlet_users defined' do
          let(:params) do
            { users_hash: {
              macron: {
                group: 'leyen',
                create_dir: true,
              },
              starmer: {
                manage_user: true,
                homedir: '/tmp/starmer',
              },
            } }
          end

          it { is_expected.to contain_quadlets__user('macron').with_group('leyen') }
          it { is_expected.to contain_quadlets__user('starmer').with_manage_user(true) }
          it { is_expected.to have_quadlets__user_resource_count(2) }

          # macron: group => leyen, create_dir => true (homedir defaults to /home/macron)
          it { is_expected.to contain_user('macron').with_gid('leyen') }
          it { is_expected.to contain_group('leyen') }
          it { is_expected.to contain_loginctl_user('macron').with_linger('enabled') }

          it {
            is_expected.to contain_file('/home/macron/.config').with(
              ensure: 'directory',
              owner: 'macron',
              group: 'leyen',
            )
          }

          it {
            is_expected.to contain_file('/home/macron/.config/containers').with(
              ensure: 'directory',
              owner: 'macron',
              group: 'leyen',
            )
          }

          it {
            is_expected.to contain_file('/home/macron/.config/containers/systemd').with(
              ensure: 'directory',
              owner: 'macron',
              group: 'leyen',
            )
          }

          it {
            is_expected.to contain_file('/etc/containers/systemd/users/macron').with(
              ensure: 'directory',
              owner: 'root',
              group: 'root',
            )
          }

          # starmer: manage_user => true, homedir => /tmp/starmer
          it { is_expected.to contain_user('starmer').with_home('/tmp/starmer') }
          it { is_expected.to contain_group('starmer') }
          it { is_expected.to contain_loginctl_user('starmer').with_linger('enabled') }

          it {
            is_expected.to contain_file('/tmp/starmer/.config').with(
              ensure: 'directory',
              owner: 'starmer',
              group: 'starmer',
            )
          }

          it {
            is_expected.to contain_file('/tmp/starmer/.config/containers').with(
              ensure: 'directory',
              owner: 'starmer',
              group: 'starmer',
            )
          }

          it {
            is_expected.to contain_file('/tmp/starmer/.config/containers/systemd').with(
              ensure: 'directory',
              owner: 'starmer',
              group: 'starmer',
            )
          }

          it {
            is_expected.to contain_file('/etc/containers/systemd/users/starmer').with(
              ensure: 'directory',
              owner: 'root',
              group: 'root',
            )
          }
        end
      end
    end
  end
end
