# frozen_string_literal: true

require 'spec_helper'

describe 'quadlets' do
  before do
    Facter.clear
    allow(Facter::Util::Resolution).to receive(:which).with('podman').and_return('/usr/bin/podman')
    allow(Facter::Core::Execution).to receive(:execute).with('/usr/bin/podman --version').and_return(podman_version_result)
  end

  context 'podman present' do
    let(:podman_version_result) { "podman version 1.2.15\n" }

    it 'returns valid fact' do
      expect(Facter.fact('quadlets').value).to eq('podman_version' => '1.2.15')
    end
  end
end
