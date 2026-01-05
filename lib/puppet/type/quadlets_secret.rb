# frozen_string_literal: true

Puppet::Type.newtype(:quadlets_secret) do
  desc <<~DESC
    Type for managing podman secrets (per user)

    @example Define a secret mysecret for user blah
     quadlets_secret{ 'blah:mysecret':
       secret => '***secret***',
     }
  DESC

  ensurable

  newparam(:name, namevar: true) do
    desc 'combination of user:secretname of the secret to administrate'

    newvalues(%r{^\S+:\S+})
  end

  newparam(:driver) do
    desc 'driver to be used for secret creation'
    defaultto 'file'
  end

  newparam(:doptions) do
    desc 'driver options used for secret creation'
    defaultto({})

    validate do |value|
      raise ArgumentError, 'needs to be a Hash' unless value.is_a?(Hash)
    end
  end

  newproperty(:labels) do
    desc 'secret labels to set'
    defaultto({})

    validate do |value|
      raise ArgumentError, 'needs to be a Hash' unless value.is_a?(Hash)
    end

    munge do |value|
      res = []
      value.keys.sort.each do |k|
        res << "#{k}=#{value[k]}"
      end
      return res.join('|')
    end
  end

  newproperty(:secret) do
    desc 'the secret himself'

    validate do |value|
      raise ArgumentError, 'needs to be a string' unless value.is_a?(String)
    end

    def should_to_s(_value)
      '*****'
    end

    def is_to_s(_value)
      '*****'
    end
  end

  autorequire(:class) { 'quadlets' }

  autorequire(:user) do
    [self[:name].split(':')[0]]
  end

  autorequire(:loginctl_user) do
    [self[:name].split(':')[0]]
  end

  autorequire(:package) do
    ['podman']
  end
end
