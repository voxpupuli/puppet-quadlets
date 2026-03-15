# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'quadlets::quadlet' do
  context 'with a simple CentOS container running' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        file { ['/etc/containers/', '/etc/containers/yaml/']:
          ensure => 'directory',
        }
        file { '/etc/containers/storage.conf':
          ensure  => 'file',
          content => @(CONF),
            [storage]
            driver = "overlay"
            runroot = "/var/lib/containers/storage"
            graphroot = "/var/lib/containers/storage"

            [storage.options.overlay]
            mount_program = "/usr/bin/fuse-overlayfs"
            | CONF
        }
        file { '/etc/containers/yaml/pod.yaml':
          content => @(POD),
            apiVersion: v1
            kind: Pod
            metadata:
              name: nginx
            spec:
              containers:
              - name: nginx
                image: quay.io/centos/centos:latest
                command:
                - sleep
                - inf
            | POD
        }
        package{'fuse-overlayfs':
          ensure => present,
          before => Quadlets::Quadlet['kubeycentos.kube'],
        }
        quadlets::quadlet{'kubeycentos.kube':
          ensure          => present,
          kube_entry     => {
           'Yaml' => '/etc/containers/yaml/pod.yaml',
          },
          service_entry       => {
            'TimeoutStartSec' => '900',
          },
          install_entry   => {
            'WantedBy' => 'default.target'
          },
          active          => true,
        }
        PUPPET
      end
    end

    describe command('systemctl cat kubeycentos.service') do
      it 'generates a service file' do
        puts subject.stdout
        expect(subject.exit_status).to eq(0)
      end
    end

    describe service('kubeycentos.service') do
      after do |example|
        if example.exception
          puts command('systemctl status kubeycentos.service --no-pager -l').stdout
          puts command('journalctl -u kubeycentos.service --no-pager -n 200').stdout
        end
      end

      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end
  end
end
