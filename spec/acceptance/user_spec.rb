# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'quadlets::user' do
  context 'with a simple user' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        $_simple = {
          name          => 'simple',
          manage_linger => false,
        }
        quadlets::user{'simple':
          user => $_simple
        }

        user{ 'nomanage':
          home       => '/opt/nomanage',
          managehome => true,
        }
        $_nomanage = {
          name          => 'nomanage',
          manage_user   => false,
          homedir       => '/opt/nomanage',
          manage_linger => false,
        }
        quadlets::user{ 'nomanage':
          user => $_nomanage
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
    end

    describe file('/opt/nomanage/.config/containers/systemd') do
      it { is_expected.to be_directory }
      it { is_expected.to be_owned_by 'nomanage' }
    end
  end
end
