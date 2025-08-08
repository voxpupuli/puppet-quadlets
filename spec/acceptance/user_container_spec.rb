# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'quadlets::quadlet' do
  context 'with a simple CentOS user container running' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET

        # We might want to fall back on fuse-overlayfs
        # rather than rely on overlay working.
        #
        package{'fuse-overlayfs':
          ensure => present,
          before => Quadlets::Quadlet['centos-user.container'],
        }
        # begin hacks to make it work on rootless in rootless container
        file_line{'contoiners_subgid':
          path   => '/etc/subgid',
          line   => 'containers:10000:5000',
          before => User['containers'],
        }
        file_line{'contoiners_subuid':
          path   => '/etc/subuid',
          line   => 'containers:10000:5000',
          before => User['containers'],
        }
        exec{'setcap_newgidmap':
          command => '/usr/sbin/setcap cap_setgid=ep /usr/bin/newgidmap',
          unless  => '/usr/sbin/getcap /usr/bin/newgidmap | grep -q cap_setgid=ep',
          before  => User['containers'],
        }
        exec{'setcap_newuidmap':
          command => '/usr/sbin/setcap cap_setuid=ep /usr/bin/newuidmap',
          unless  => '/usr/sbin/getcap /usr/bin/newuidmap | grep -q cap_setuid=ep',
          before  => User['containers'],
        }
        # end hacks to make it work on rootless in rootless container
        user{'containers':
          ensure     => present,
          managehome => true,
        }
        loginctl_user{'containers':
          linger  => enabled,
        }
        file{['/home/containers/.config', '/home/containers/.config/containers', '/home/containers/.config/containers/systemd']:
          ensure => directory,
          owner  => 'containers',
          group  => 'containers',
        }
        quadlets::quadlet{'centos-user.container':
          ensure          => present,
          user            => {
            'name' => 'containers',
          },
          unit_entry      => {
           'Description' => 'Trivial Container that will be very lazy',
          },
          service_entry   => {
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

    describe 'centos.service user unit' do
      it 'is running' do
        result = command('systemctl --user --machine containers@ is-active centos-user.service')
        expect(result.stdout.strip).to eq('active')
      end

      it 'is enabled' do
        result = command('systemctl --user --machine containers@ is-enabled centos-user.service')
        expect(result.stdout.strip).to eq('generated')
      end
    end
  end
end
