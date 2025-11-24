# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'quadlets::user' do
  context 'with a selection of users' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        quadlets::user{'simple':
          manage_linger   => false,
          authentications => { 'myregistry.com' => {
            'username' => 'test',
            'password' => '*secret*'
          } },
        }

        quadlets::user{'grpuser':
          group         => 'grpgrp',
          manage_linger => false,
        }

        user{ 'nomanage':
          home       => '/opt/nomanage',
          managehome => true,
        }

        quadlets::user{ 'nomanage':
          manage_user   => false,
          homedir       => '/opt/nomanage',
          manage_linger => false,
        }

        quadlets::user{ 'strange':
          name          => 'strange',
          manage_linger => false,
          subuid        => [1000,2000],
          subgid        => [3000,4000],
        }

        quadlets::user{ 'top':
          name          => 'top',
          group         => 'bottom',
          manage_linger => false,
          subuid        => [1010,1011],
          subgid        => [1012,1013],
        }

        quadlets::user{ 'charm':
          name              => 'charm',
          manage_linger     => false,
          manage_user       => false,
          create_dir        => false,
          create_system_dir => false,
          subuid            => [5000,6000],
          subgid            => [7000,8000],
        }

        PUPPET
      end
    end

    describe user('simple') do
      it { is_expected.to exist }
      it { is_expected.to belong_to_primary_group 'simple' }
    end

    describe file('/home/simple/.config/containers/systemd') do
      it { is_expected.to be_directory }
      it { is_expected.to be_owned_by 'simple' }
      it { is_expected.to be_grouped_into 'simple' }
    end

    describe file('/home/simple/.config/containers/auth.json') do
      it { is_expected.to be_file }
      it { is_expected.to be_owned_by 'simple' }
    end

    describe file('/etc/containers/systemd/users/simple') do
      it { is_expected.to be_directory }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
    end

    describe user('grpuser') do
      it { is_expected.to exist }
      it { is_expected.to belong_to_primary_group 'grpgrp' }
    end

    describe file('/home/grpuser/.config/containers/systemd') do
      it { is_expected.to be_directory }
      it { is_expected.to be_owned_by 'grpuser' }
      it { is_expected.to be_grouped_into 'grpgrp' }
    end

    describe file('/opt/nomanage/.config/containers/systemd') do
      it { is_expected.to be_directory }
      it { is_expected.to be_owned_by 'nomanage' }
    end

    describe file('/etc/subuid') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match %r{^strange:1000:2000$} }
      its(:content) { is_expected.to match %r{^charm:5000:6000$} }
      its(:content) { is_expected.to match %r{^top:1010:1011$} }
    end

    describe file('/etc/subgid') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match %r{^strange:3000:4000} }
      its(:content) { is_expected.to match %r{^charm:7000:8000$} }
      its(:content) { is_expected.to match %r{^bottom:1012:1013$} }
    end
  end

  context 'updating an existing subuid, subgid' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        quadlets::user{ 'top':
          name          => 'top',
          group         => 'bottom',
          manage_linger => false,
          subuid        => [2010,2011],
          subgid        => [2012,2013],
        }
        PUPPET
      end
    end

    describe file('/etc/subuid') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match %r{^strange:1000:2000$} }
      its(:content) { is_expected.to match %r{^charm:5000:6000$} }
      its(:content) { is_expected.not_to match %r{^top:1010:1011$} }
      its(:content) { is_expected.to match %r{^top:2010:2011$} }
    end

    describe file('/etc/subgid') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match %r{^strange:3000:4000} }
      its(:content) { is_expected.to match %r{^charm:7000:8000$} }
      its(:content) { is_expected.not_to match %r{^bottom:1012:1013$} }
      its(:content) { is_expected.to match %r{^bottom:2012:2013$} }
    end
  end
end
