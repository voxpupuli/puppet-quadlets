# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'quadlets_secret' do
  context 'with a selection of secrets for root and auser' do
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

        quadlets_secret{'root:withpath':
          secret   => 'Idonottellyou;)',
          doptions => {
            path => '/tmp/whithpathsecret',
          },
        }
        PUPPET
      end
    end

    it 'root:asecret exists' do
      result = command('podman secret ls --filter Name=asecret -n --format "{{.Name}}"')
      expect(result.stdout.strip).to eq('asecret')
    end

    it 'root:anothersecret has labels' do
      result = command('podman secret inspect anothersecret --format "{{.Spec.Labels}}"')
      expect(result.stdout.strip).to eq('map[label1:one label2:two]')
    end

    describe user('auser') do
      it { is_expected.to exist }
    end

    describe 'directories for secret with path set' do
      describe file('/tmp/whithpathsecret') do
        it { is_expected.to be_directory }
        it { is_expected.to be_owned_by 'root' }
        it { is_expected.to be_grouped_into 'root' }
      end
    end

    describe 'file for secret with path set' do
      describe file('/tmp/whithpathsecret/secretsdata.json') do
        it { is_expected.to be_file }
        it { is_expected.to be_owned_by 'root' }
        it { is_expected.to be_grouped_into 'root' }
      end
    end
  end
end
