# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'quadlets::user' do
  context 'with a simple user' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        quadlets::user{'simple':
          manage_linger => false,
        }

        user{ 'nomanage':
          home       => '/opt/nomanage',
          managehome => true,
        }
        $_nomanage = {
          name          => 'nomanage',
        }
        quadlets::user{ 'nomanage':
          manage_user   => false,
          homedir       => '/opt/nomanage',
          manage_linger => false,
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
