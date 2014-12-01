require 'grant-front/version'
require 'grant-front/rails' if defined? Rails::Railtie

module GrantFront
  class << self
    attr_accessor :authorizations, :store

    def draw
      self.store = true
      self.authorizations = []
      self.setup
      self.policies.each do |klass|
        self.roles(klass)
      end
      self.store = false
      self.authorizations
    end

    def setup
      Dir.glob(File.expand_path('./app/policies/*.rb', Rails.root)).each do |name|
        require name
      end
    end

    def policies
      Object.constants.inject([]) do |arr, name|
        unless name == :Config
          klass = Object.const_get(name)
          if klass.class == Class && klass.superclass == ApplicationPolicy
            arr << klass
          end
        end
        arr
      end
    end

    def roles(klass=nil)
      user = Struct.new(:id, :roles).new(1, [])
      policy = klass.new(user, user)
      policy.methods.each do |name|
        if name =~ /\?$/
          owner = policy.method(name).owner
          if owner == klass or owner == ApplicationPolicy
            self.authorizations << {class: klass, method: name, roles: []}
            policy.send(name)
          end
        end
      end
    end
  end
end
