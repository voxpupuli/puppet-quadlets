# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'quadlets::quadlet' do
  context 'with a simple CentOS container running' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        file { '/etc/containers/yaml/':
          ensure => 'directory',
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
        quadlets::quadlet{'centos.kube':
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

    describe service('centos.service') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end
  end
end