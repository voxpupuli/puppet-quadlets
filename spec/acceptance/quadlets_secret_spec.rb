# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'quadlets_secret' do
  context 'with a selection of users' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        include quadlets

        quadlets_secret{'root:asecret':
          secret => 'whoknows',
        }

        quadlets_secret{'root:anothersecret':
          secret => 'justguess',
          labels => {
            label1 => 'one',
            label2 => 'two',
          },
        }

        quadlets_secret{'auser:ausersecret':
          secret => 'toosimple',
          labels => {
            label3 => 'three',
            label4 => 'four',
          },
        }

        quadlets_secret{'auser:othersecret':
          secret   => 'Idonottellyou;)',
          doptions => {
            path => '/tmp/othersecret',
          },

        user{ 'auser':
          home       => '/tmp/auser',
          managehome => true,
        }

        PUPPET
      end
    end

    it 'root:asecret exists' do
      result = command('podman secret ls --filter Name=asecret -n --format "{{.Name}}"')
      expect(result.stdout.strip).to eq('asecret')
    end

    it 'root:anothersecret has labels' do
      result = command('podman secret inspect anotersecret --format "{{.Spec.Labels}}"')
      expect(result.stdout.strip).to eq('map[label1:one label2:two]')
    end

    describe user('auser') do
      it { is_expected.to exist }
    end

    describe 'directory for auser secrets' do
      file('/tmp/auser/.local/share/containers/containers/storage/secrets') do
        it { is_expected.to be_directory }
        it { is_expected.to be_owned_by 'auser' }
        it { is_expected.to be_grouped_into 'auser' }
      end
    end

    describe 'files for auser secrets' do
      describe file('/tmp/auser/.local/share/containers/containers/storage/secrets/secrets.json') do
        it { is_expected.to be_file }
        it { is_expected.to be_owned_by 'auser' }
        it { is_expected.to be_grouped_into 'auser' }
      end
    end

    describe 'directories for secret with path set' do
      describe file('/tmp/othersecret') do
        it { is_expected.to be_directory }
        it { is_expected.to be_owned_by 'auser' }
        it { is_expected.to be_grouped_into 'auser' }
      end
    end

    describe 'file for secret with path set' do
      describe file('/tmp/othersecret/secretsdata.json') do
        it { is_expected.to be_file }
        it { is_expected.to be_owned_by 'auser' }
        it { is_expected.to be_grouped_into 'auser' }
      end
    end
  end
end
