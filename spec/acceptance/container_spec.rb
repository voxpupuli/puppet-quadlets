# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'quadlets::quadlet' do
  context 'with a simple CentOS container running' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET

        # We might want to fall back on fuse-overlayfs
        # rather than rely on overlay working.
        #
        package{'fuse-overlayfs':
          ensure => present,
          before => Quadlets::Quadlet['centos.container'],
        }
        quadlets::quadlet{'centos.container':
          ensure          => present,
          unit_entry     => {
           'Description' => 'Trivial Container that will be very lazy',
          },
          service_entry       => {
            'TimeoutStartSec' => '900',
          },
          container_entry => {
            'Image'  => 'quay.io/centos/centos:latest',
            'Exec'   => 'sh -c "sleep inf"',
          },
          install_entry   => {
            'WantedBy' => 'default.target',
          },
          active          => true,
        }
        PUPPET
      end
    end

    describe service('centos.service') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end
  end
end
