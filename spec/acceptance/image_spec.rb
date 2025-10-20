# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'quadlets::quadlet' do
  context 'with a simple busybox image to download' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET

        quadlets::quadlet{'busybox.image':
          ensure          => present,
          unit_entry     => {
           'Description' => 'Download the busybox image',
          },
          service_entry       => {
            'TimeoutStartSec' => '900',
          },
          image_entry => {
            'Image'  => 'docker.io/busybox',
          },
          install_entry   => {
            'WantedBy' => 'default.target',
          },
          active          => true,
        }
        PUPPET
      end
    end

    describe service('busybox-image.service') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end
  end
end
