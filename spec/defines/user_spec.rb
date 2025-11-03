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
      end

      context 'with a simple user actions disabled' do
        let(:title) { 'micro' }
        let(:params) do
          {
            user: 'micro',
            manage_linger: false,
            manage_user: false,
            create_dir: false,
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.not_to contain_user('micro') }
        it { is_expected.not_to contain_loginctl_user('micro') }
        it { is_expected.not_to contain_file('/home/mirco/.config/containers/systemd') }
      end
    end
  end
end
