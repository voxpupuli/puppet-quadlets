# frozen_string_literal: true

require 'spec_helper'

describe 'quadlets::user' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts
      end

      context 'with a simple user' do
        let(:title) { 'nano' }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_user('nano') }
        it { is_expected.to contain_loginctl_user('nano').with_linger('enabled') }

        it {
          is_expected.to contain_file('/home/nano/.config/containers/systemd').with(
            {
              ensure: 'directory',
              owner: 'nano',
              group: 'nano',
            }
          )
        }

        it {
          is_expected.to contain_file('/etc/containers/systemd/users/nano').with(
            {
              ensure: 'directory',
              owner: 'root',
              group: 'root',
            }
          )
        }

        it { is_expected.not_to contain_file('/home/charm/.config/containers/auth.json') }
      end

      context 'with a simple user and group' do
        let(:title) { 'pico' }
        let(:params) do
          { 'group' => 'giga' }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_user('pico').with_gid('giga') }
        it { is_expected.to contain_loginctl_user('pico').with_linger('enabled') }

        it {
          is_expected.to contain_file('/home/pico/.config/containers/systemd').with(
            {
              ensure: 'directory',
              owner: 'pico',
              group: 'giga',
            }
          )
        }

        it { is_expected.not_to contain_augeas('subuid_nano') }
        it { is_expected.not_to contain_augeas('subgid_nano') }
      end

      context 'with a simple user actions disabled' do
        let(:title) { 'micro' }
        let(:params) do
          {
            user: 'micro',
            manage_linger: false,
            manage_user: false,
            create_dir: false,
            create_system_dir: false,
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.not_to contain_user('micro') }
        it { is_expected.not_to contain_loginctl_user('micro') }
        it { is_expected.not_to contain_file('/home/mirco/.config/containers/systemd') }
        it { is_expected.not_to contain_file('/etc/containers/systemd/users/micro') }
      end

      context 'with a subuid and subgid set' do
        let(:title) { 'quark' }
        let(:params) do
          {
            'subuid' => [700, 1000],
            'subgid' => [1000, 2000],
          }
        end

        it { is_expected.to compile.with_all_deps }

        it {
          is_expected.to contain_augeas('subuid_quark').with(
            {
              changes: [
                'set quark/start 700', 'set quark/count 1000',
                'rm quark[2]', 'rm quark[2]', 'rm quark[2]',
              ],
              lens: 'Subids.lns',
              incl: '/etc/subuid',
              context: '/files/etc/subuid',
            }
          )
        }

        it {
          is_expected.to contain_augeas('subgid_quark').with(
            {
              changes: [
                'set quark/start 1000', 'set quark/count 2000',
                'rm quark[2]', 'rm quark[2]', 'rm quark[2]'
              ],
              lens: 'Subids.lns',
              incl: '/etc/subgid',
              context: '/files/etc/subgid',
            }
          )
        }

        context 'with a specified group' do
          let(:params) do
            super().merge(group: 'top')
          end

          it { is_expected.to contain_augeas('subuid_quark') }

          it {
            is_expected.to contain_augeas('subgid_top').with(
              {
                changes: [
                  'set top/start 1000', 'set top/count 2000',
                  'rm top[2]', 'rm top[2]', 'rm top[2]'
                ],
                lens: 'Subids.lns',
                incl: '/etc/subgid',
                context: '/files/etc/subgid',
              }
            )
          }
        end
      end

      context 'with manage_user false subuid and subgid set' do
        let(:title) { 'charm' }
        let(:params) do
          {
            'name'        => 'charm',
            'manage_user' => false,
            'subuid'      => [900, 1000],
            'subgid'      => [900, 1000],
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.not_to contain_user('charm') }
        it { is_expected.to contain_augeas('subuid_charm') }
        it { is_expected.to contain_augeas('subgid_charm') }
      end

      context 'with authentication set' do
        let(:title) { 'charm' }
        let(:params) do
          {
            'authentications' => { 'myregistry.com': { username: 'test', password: '*secret*' } },
          }
        end

        it { is_expected.to compile.with_all_deps }

        it {
          is_expected.to contain_file('/home/charm/.config/containers/auth.json').
            with_ensure('file').
            with_owner('charm').
            with_group('charm').
            with_mode('0600')
        }
      end
    end
  end
end
