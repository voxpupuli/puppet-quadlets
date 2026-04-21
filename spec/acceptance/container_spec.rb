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

  context 'with Exec as an array equivalent to the string form' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET

        package{'fuse-overlayfs':
          ensure => present,
          before => Quadlets::Quadlet['node-exporter.container'],
        }
        quadlets::quadlet{'node-exporter.container':
          ensure          => present,
          unit_entry      => {
            'Description' => 'Prometheus node-exporter (string Exec)',
          },
          container_entry => {
            'Image' => 'quay.io/prometheus/node-exporter:latest',
            'Exec'  => '--path.procfs=/host/proc --path.sysfs=/host/sys --path.rootfs=/host --web.listen-address=[::]:9100',
          },
          install_entry   => {
            'WantedBy' => 'default.target',
          },
        }
        PUPPET
      end
    end

    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET

        package{'fuse-overlayfs':
          ensure => present,
          before => Quadlets::Quadlet['node-exporter-array.container'],
        }
        quadlets::quadlet{'node-exporter-array.container':
          ensure          => present,
          unit_entry      => {
            'Description' => 'Prometheus node-exporter (array Exec)',
          },
          container_entry => {
            'Image' => 'quay.io/prometheus/node-exporter:latest',
            'Exec'  => [
              '--path.procfs=/host/proc',
              '--path.sysfs=/host/sys',
              '--path.rootfs=/host',
              '--web.listen-address=[::]:9100',
            ],
          },
          install_entry   => {
            'WantedBy' => 'default.target',
          },
        }
        PUPPET
      end
    end

    it 'produces identical Exec= lines from string and array forms' do
      string_exec = file('/etc/containers/systemd/node-exporter.container').content.match(%r{^Exec=.+$})
      array_exec  = file('/etc/containers/systemd/node-exporter-array.container').content.match(%r{^Exec=.+$})
      expect(string_exec).to eq(array_exec)
    end
  end
end
