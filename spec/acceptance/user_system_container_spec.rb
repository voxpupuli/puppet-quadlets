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
          before => Quadlets::Quadlet['centos-system-user.container'],
        }
        # systemd-logind is masked on almalinux, enable it because it is needed
        # for user containers
        service{'systemd-logind.service':
          ensure => true,
          enable => true,
        }
        if $facts['os']['family'] != 'Debian' {
          exec{'setcap_newgidmap':
            command => '/usr/sbin/setcap cap_setgid=ep /usr/bin/newgidmap',
            unless  => '/usr/sbin/getcap /usr/bin/newgidmap | grep -q cap_setgid=ep',
            before  => User['robot'],
          }
          exec{'setcap_newuidmap':
            command => '/usr/sbin/setcap cap_setuid=ep /usr/bin/newuidmap',
            unless  => '/usr/sbin/getcap /usr/bin/newuidmap | grep -q cap_setuid=ep',
            before  => User['robot'],
          }
        }
        # end hacks to make it work on rootless in rootless container
        quadlets::user{'robot':
          subuid => [20000,5000],
          subgid => [20000,5000],
        }

        # https://github.com/voxpupuli/puppet-systemd/issues/578
        exec{'allow_systemd --user_to_start':
          command => '/usr/bin/sleep 15 && touch /tmp/robot-run-only-once',
          creates => '/tmp/robot-run-only-once',
          require => Quadlets::User['robot'],
          before  => Quadlets::Quadlet['centos-system-user.container'],
        }

        quadlets::quadlet{'centos-system-user.container':
          ensure          => present,
          user            => 'robot',
          location        => 'system',
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

    describe file('/etc/containers/systemd/users/robot/centos-system-user.container') do
      it { is_expected.to be_file }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
    end

    describe 'centos-system-user.service user unit' do
      it 'is running' do
        result = command('systemctl --user --machine robot@ is-active centos-system-user.service')
        expect(result.stdout.strip).to eq('active')
      end

      it 'is enabled' do
        result = command('systemctl --user --machine robot@ is-enabled centos-system-user.service')
        expect(result.stdout.strip).to eq('generated')
      end
    end
  end
end
