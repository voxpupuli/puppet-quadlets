# frozen_string_literal: true

describe 'quadlets::quadlet' do
  context 'with 3 simple CentOS user containers of 2 different users running' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET

        # We might want to fall back on fuse-overlayfs
        # rather than rely on overlay working.
        #
        package{'fuse-overlayfs':
          ensure => present,
          before => [Quadlets::Quadlet['centos-user1.container'],Quadlets::Quadlet['centos-user2.container']],
        }
        # systemd-logind is masked on almalinux, enable it because it is needed
        # for user containers
        service{'systemd-logind.service':
          ensure => true,
          enable => true,
        }
        # begin hacks to make it work on rootless in rootless container
        if $facts['os']['family'] != 'Debian' {
          exec{'setcap_newgidmap':
            command => '/usr/sbin/setcap cap_setgid=ep /usr/bin/newgidmap',
            unless  => '/usr/sbin/getcap /usr/bin/newgidmap | grep -q cap_setgid=ep',
            before  => [User['containers'],User['steve']],
          }
          exec{'setcap_newuidmap':
            command => '/usr/sbin/setcap cap_setuid=ep /usr/bin/newuidmap',
            unless  => '/usr/sbin/getcap /usr/bin/newuidmap | grep -q cap_setuid=ep',
            before  => [User['containers'],User['steve']],
          }
        }
        # end hacks to make it work on rootless in rootless container
        quadlets::user{'containers':
          subuid => [10000, 5000],
          subgid => [10000, 5000],
        }

        exec{'allow_systemd --user_to_start containers':
          command => '/usr/bin/sleep 10 && touch /tmp/run-only-once-containers',
          creates => '/tmp/run-only-once-containers',
          require => Quadlets::User['containers'],
          before  => [Quadlets::Quadlet['centos-user1.container'],Quadlets::Quadlet['centos-user2.container']],
        }

        quadlets::quadlet{'centos-user1.container':
          ensure          => present,
          user            => 'containers',
          unit_entry      => {
           'Description' => 'Trivial First Container that will be very lazy',
          },
          service_entry   => {
            'TimeoutStartSec' => '900',
          },
          container_entry => {
            'Image'   => 'quay.io/centos/centos:latest',
            'Exec'    => 'sh -c "sleep inf"',
            'Network' => 'host',
          },
          install_entry   => {
            'WantedBy' => 'default.target',
          },
          active          => true,
        }
        quadlets::quadlet{'centos-user2.container':
          ensure          => present,
          user            => 'containers',
          unit_entry      => {
           'Description' => 'Trivial Second Container that will be very lazy',
          },
          service_entry   => {
            'TimeoutStartSec' => '900',
          },
          container_entry => {
            'Image'   => 'quay.io/centos/centos:latest',
            'Exec'    => 'sh -c "sleep inf"',
            'Network' => 'host',
          },
          install_entry   => {
            'WantedBy' => 'default.target',
          },
          active          => true,
        }
        file { ['/nfs', '/nfs/home']:
          ensure => 'directory',
        }
        quadlets::user{'steve':
          user          => 'steve',
          create_dir    => true,
          manage_user   => true,
          manage_linger => true,
          homedir       => '/nfs/home/steve',
          subuid        => [15000, 5000],
          subgid        => [15000, 5000],
        }

        exec{'allow_systemd --user_to_start steve':
          command => '/usr/bin/sleep 10 && touch /tmp/run-only-once-steve',
          creates => '/tmp/run-only-once-steve',
          require => Quadlets::User['steve'],
          before  => Quadlets::Quadlet['centos-user3.container'],
        }

        quadlets::quadlet{'centos-user3.container':
          ensure          => present,
          user            => 'steve',
          homedir         => '/nfs/home/steve',
          unit_entry      => {
           'Description' => 'Trivial Third Container that will be very lazy',
          },
          service_entry   => {
            'TimeoutStartSec' => '900',
          },
          container_entry => {
            'Image'   => 'quay.io/centos/centos:latest',
            'Exec'    => 'sh -c "sleep inf"',
            'Network' => 'host',
          },
          install_entry   => {
            'WantedBy' => 'default.target',
          },
          active          => true,
        }
        PUPPET
      end
    end

    describe 'centos.service user1 unit' do
      it 'is running' do
        result = command('systemctl --user --machine containers@ is-active centos-user1.service')
        expect(result.stdout.strip).to eq('active')
      end

      it 'is enabled' do
        result = command('systemctl --user --machine containers@ is-enabled centos-user1.service')
        expect(result.stdout.strip).to eq('generated')
      end
    end

    describe 'centos.service user2 unit' do
      it 'is running' do
        result = command('systemctl --user --machine containers@ is-active centos-user2.service')
        expect(result.stdout.strip).to eq('active')
      end

      it 'is enabled' do
        result = command('systemctl --user --machine containers@ is-enabled centos-user2.service')
        expect(result.stdout.strip).to eq('generated')
      end
    end

    describe 'centos.service user3 unit' do
      it 'is running' do
        result = command('systemctl --user --machine steve@ is-active centos-user3.service')
        expect(result.stdout.strip).to eq('active')
      end

      it 'is enabled' do
        result = command('systemctl --user --machine steve@ is-enabled centos-user3.service')
        expect(result.stdout.strip).to eq('generated')
      end
    end
  end
end
