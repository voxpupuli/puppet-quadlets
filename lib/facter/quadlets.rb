# frozen_string_literal: true

#
# Structured fact describing podman / quadlets on this node.
#
#   podman_version: version from `podman --version`, e.g. "podman version 5.4.2" => "5.4.2"
#   users:          one entry per file in /var/lib/quadlets-users-fact.d, where the
#                   file name is a username, resolved to its uid:
#                   { 'alice' => { 'uid' => 1001 }, ... }
#
require 'etc'

Facter.add(:quadlets) do
  @podman_cmd = Facter::Core::Execution.which('podman')
  confine { @podman_cmd }

  setcode do
    users_dir = '/var/lib/quadlets-users-fact.d'

    version = Facter::Core::Execution.execute(%(#{@podman_cmd} --version))[%r{^podman version (.*)$}, 1]

    users = {}
    if File.directory?(users_dir)
      Dir.children(users_dir).sort.each do |name|
        next if name.start_with?('.')
        next unless File.file?(File.join(users_dir, name))

        begin
          users[name] = { 'uid' => Etc.getpwnam(name).uid }
        rescue ArgumentError
          Facter.debug("quadlets: no passwd entry for user '#{name}', skipping")
        end
      end
    end

    {
      'podman_version' => version,
      'users' => users,
    }
  end
end
