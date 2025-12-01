# frozen_string_literal: true

#
# This file contains a provider for the resource type `libvirt_nwfilter`,
#

require 'json'

Puppet::Type.type(:quadlets_secret).provide(:podman) do
  desc "@summary provider for the resource type `quadlets_secret`,
        which manages quadlet secrets
        using the podman command."

  commands podman: 'podman'

  def should_user
    @should_user || @should_user = resource[:name].split(':')[0]
  end

  def should_secretname
    @should_secretname || @should_secretname = resource[:name].split(':')[1]
  end

  def hash_to_array(inhash)
    res = []
    if inhash
      inhash.keys.sort.each do |k|
        res << "#{k}=#{inhash[k]}"
      end
    end
    res
  end

  def run_podman(args, env = {})
    user_info = Etc.getpwnam(should_user)
    # sysenv = { 'HOME' => user_info.dir, 'XDG_RUNTIME_DIR' => "/run/user/#{user_info.uid}" }
    # sysenv = { 'HOME' => user_info.dir, 'XDG_RUNTIME_DIR' => "/run/user/#{user_info.uid}" }
    runenv = {
      cwd: user_info.dir,
      failonfail: true,
      uid: user_info.uid,
      gid: user_info.gid,
      combine: false,
      custom_environment: env.merge({ 'HOME' => user_info.dir, 'XDG_RUNTIME_DIR' => "/run/user/#{user_info.uid}" })
    }

    execute([command('podman')] + args, runenv)
  end

  def create_secret(replace)
    args = ['secret', 'create', should_secretname, '--env', 'psecret']

    if replace
      args << "-d=#{@result['Spec']['Driver']['Name']}"
      hash_to_array(@result['Spec']['Driver']['Options']).each do |d|
        args << "--driver-opts=#{d}"
      end
      args << '--replace'
    else
      args << "-d=#{@resource[:driver]}"
      hash_to_array(resource[:doptions]).each do |d|
        args << "--driver-opts=#{d}"
      end
    end

    resource[:labels]&.split('|')&.each do |l|
      args << "-l=#{l}"
    end

    run_podman(args, { 'psecret' => @resource[:secret] })
  end

  def create
    create_secret(false)
  end

  def destroy
    run_podman(['secret', 'rm', should_secretname])
  end

  def labels=(_label)
    create_secret(true)
  end

  def labels
    hash_to_array(@result['Spec']['Labels']).join('|') if @result
  end

  def secret=(_secret)
    create_secret(true)
  end

  def secret
    @result['SecretData'] if @result
  end

  def exists?
    begin
      res = run_podman(['secret', 'inspect', should_secretname, '--showsecret'])
    rescue Puppet::ExecutionFailure
      return false
    end
    @result = JSON.parse(res)[0]
  end
end
