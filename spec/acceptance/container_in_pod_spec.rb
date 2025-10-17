# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'quadlets::quadlet' do
  context 'with a container in a pod' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET

        # We might want to fall back on fuse-overlayfs
        # rather than rely on overlay working.
        #
        package{'fuse-overlayfs':
          ensure => present,
          before => Quadlets::Quadlet['podcentos.pod'],
        }

        quadlets::quadlet{'podcentos.pod':
          ensure => present,
          unit_entry     => {
            'Description' => 'Trivial Pod',
          },
          pod_entry      => {
            # work-around for https://github.com/voxpupuli/beaker-docker/issues/171
            'PodmanArgs' => '--infra-image=registry.k8s.io/pause:3.9',
          },
          active          => true,
        }

        quadlets::quadlet{'podcentos.container':
          ensure          => present,
          unit_entry     => {
           'Description' => 'Trivial Container in the Pod above',
          },
          service_entry       => {
            'TimeoutStartSec' => '900',
          },
          container_entry => {
            'Image'  => 'quay.io/centos/centos:latest',
            'Exec'   => 'sh -c "sleep inf"',
            'Pod'    => 'podcentos.pod',
          },
          install_entry   => {
            'WantedBy' => 'default.target',
          },
          active          => true,
          # This will not validate unless pod is on disk.
          require         => Quadlets::Quadlet['podcentos.pod'],
        }
        PUPPET
      end
    end

    %w[podcentos.service podcentos-pod.service].each do |svc|
      describe service(svc) do
        it { is_expected.to be_running }
        it { is_expected.to be_enabled }
      end
    end
  end
end
