# frozen_string_literal: true

require 'spec_helper'
require 'etc'

describe 'quadlets' do
  let(:users_dir) { '/var/lib/quadlets-users-fact.d' }
  let(:podman_version_result) { "podman version 1.2.15\n" }

  before do
    Facter.clear
    allow(Facter::Core::Execution).to receive(:which).with('podman').and_return('/usr/bin/podman')
    allow(Facter::Core::Execution).to receive(:execute).with('/usr/bin/podman --version').and_return(podman_version_result)
    allow(File).to receive(:directory?).and_call_original
  end

  context 'when podman is absent' do
    before do
      allow(Facter::Core::Execution).to receive(:which).with('podman').and_return(nil)
    end

    it 'does not resolve' do
      expect(Facter.fact('quadlets').value).to be_nil
    end
  end

  context 'without a users directory' do
    before do
      allow(File).to receive(:directory?).with(users_dir).and_return(false)
    end

    it 'returns the podman version and no users' do
      expect(Facter.fact('quadlets').value).to eq('podman_version' => '1.2.15', 'users' => {})
    end
  end

  context 'with a users directory' do
    before do
      allow(File).to receive(:directory?).with(users_dir).and_return(true)
      allow(Dir).to receive(:children).and_call_original
      allow(Dir).to receive(:children).with(users_dir).and_return(%w[robot .hidden subdir ghost alice])
      allow(File).to receive(:file?).and_call_original
      %w[robot ghost alice].each do |name|
        allow(File).to receive(:file?).with("#{users_dir}/#{name}").and_return(true)
      end
      allow(File).to receive(:file?).with("#{users_dir}/subdir").and_return(false)
      allow(Etc).to receive(:getpwnam).with('robot').and_return(instance_double(Etc::Passwd, uid: 1001))
      allow(Etc).to receive(:getpwnam).with('alice').and_return(instance_double(Etc::Passwd, uid: 1002))
      allow(Etc).to receive(:getpwnam).with('ghost').and_raise(ArgumentError, "can't find user for ghost")
      allow(Facter).to receive(:debug)
    end

    it 'resolves known users to uids' do
      expect(Facter.fact('quadlets').value).to eq(
        'podman_version' => '1.2.15',
        'users' => {
          'alice' => { 'uid' => 1002 },
          'robot' => { 'uid' => 1001 },
        },
      )
    end

    it 'returns users sorted by name' do
      expect(Facter.fact('quadlets').value['users'].keys).to eq(%w[alice robot])
    end

    it 'ignores dotfiles and directories' do
      Facter.fact('quadlets').value
      expect(Etc).not_to have_received(:getpwnam).with('.hidden')
      expect(Etc).not_to have_received(:getpwnam).with('subdir')
    end

    it 'logs and skips unknown users' do
      Facter.fact('quadlets').value
      expect(Facter).to have_received(:debug).with("quadlets: no passwd entry for user 'ghost', skipping")
    end
  end
end
