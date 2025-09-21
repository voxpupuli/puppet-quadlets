# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'quadlets::quadlet' do
  context 'with an invalid volume defintion' do
    let(:manifest) do
      <<-PUPPET
      # This volume has a type but no Device so is invalid
      # for "podman-system-generator"
      quadlets::quadlet { 'bad.volume':
        ensure       => present,
        unit_entry   => {
          'Description' => 'Bad Volume',
        },
        volume_entry => {
         'VolumeName' => 'bad',
         'Driver'     => 'local',
         'Type'       => 'bind',
        },
      }
      # And a good volume for comparison.
      quadlets::quadlet { 'good.volume':
        ensure       => present,
        unit_entry   => {
          'Description' => 'Good Volume',
        },
        volume_entry => {
         'VolumeName' => 'good',
         'Driver'     => 'local',
         'Device'     => '/srv/good',
         'Type'       => 'bind',
        },
      }

      PUPPET
    end

    it 'applies with failures (as expected)' do
      res = apply_manifest(manifest, expect_failures: true)
      expect(res.stderr + res.stdout).to match(%r{converting "bad.volume": key Type can't be used without Device})
    end

    describe file('/etc/containers/systemd/bad.volume') {
      it { is_expected.not_to exist }
    }
    describe file('/etc/containers/systemd/good.volume') {
      it { is_expected.to exist }
    }
  end
end
