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
        # systemd-logind is masked on almalinux, enable it because it is needed
        # for user containers
        service{'systemd-logind.service':
          ensure => true,
          enable => true,
        }
        # begin hacks to make it work on rootless in rootless container
        file_line{'containers_subgid':
          path   => '/etc/subgid',
          line   => 'containers:10000:5000',
          before => User['containers'],
        }
        file_line{'containers_subuid':
          path   => '/etc/subuid',
          line   => 'containers:10000:5000',
          before => User['containers'],
        }
        if $facts['os']['family'] != 'Debian' {
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
        }
        # end hacks to make it work on rootless in rootless container
        $_containers = {
          name => 'containers',
        }
        quadlets::user{'containers':
          user => $_containers,
        }
        # https://github.com/voxpupuli/puppet-systemd/issues/578
        exec{'allow_systemd_user_to_start':
          command => '/usr/bin/sleep 10 && touch /tmp/run-only-once',
          creates => '/tmp/run-only-once',
          require => Quadlets::User['containers'],
          before  => Quadlets::Quadlet['centos-user.container'],
        }
        quadlets::quadlet{'centos-user.container':
          ensure          => present,
          user            => $_containers,
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
        file_line{'containers_subgid':
          path   => '/etc/subgid',
          line   => 'containers:10000:5000',
          before => User['containers'],
        }
        file_line{'containers_subuid':
          path   => '/etc/subuid',
          line   => 'containers:10000:5000',
          before => User['containers'],
        }
        file_line{'steve_subgid':
          path   => '/etc/subgid',
          line   => 'steve:15000:5000',
          before => User['steve'],
        }
        file_line{'steve_subuid':
          path   => '/etc/subuid',
          line   => 'steve:15000:5000',
          before => User['steve'],
        }
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
        $_containers = {
          name => 'containers',
        }
        quadlets::quadlet{'centos-user1.container':
          ensure          => present,
          user            => $_containers,
          unit_entry      => {
           'Description' => 'Trivial First Container that will be very lazy',
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
        quadlets::quadlet{'centos-user2.container':
          ensure          => present,
          user            => $_containers,
          unit_entry      => {
           'Description' => 'Trivial Second Container that will be very lazy',
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
        file { ['/nfs', '/nfs/home']:
          ensure => 'directory',
        }
        $_steve = {
          'name'          => 'steve',
          'create_dir'    => true,
          'manage_user'   => true,
          'manage_linger' => true,
          'homedir'       => '/nfs/home/steve',
        }
        quadlets::user{'steve':
          user => $_steve,
        }
        quadlets::quadlet{'centos-user3.container':
          ensure          => present,
          user            => $_steve,
          unit_entry      => {
           'Description' => 'Trivial Third Container that will be very lazy',
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
