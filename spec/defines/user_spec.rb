# frozen_string_literal: true

require 'spec_helper'

describe 'quadlets::user' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with a simple user image' do
        let(:title) { 'nano' }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_user('nano') }
        it { is_expected.to contain_user('nano').with_foo }
        it { is_expected.to contain_loginctl_user('nano').with_linger('enabled') }
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
      end
    end
  end
end
