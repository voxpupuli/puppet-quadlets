# frozen_string_literal: true

#
# Produce the version of podman (podman --version)
# podman version 5.4.2

Facter.add(:quadlets) do
  @podman_cmd = Facter::Util::Resolution.which('podman')
  confine { @podman_cmd }

  setcode do
    version = Facter::Core::Execution.execute(%(#{@podman_cmd} --version))[%r{^podman version (.*)$}, 1]
    {
      'podman_version' => version,
    }
  end
end
