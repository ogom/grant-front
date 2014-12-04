require_relative 'grant-front/version'
require_relative 'grant-front/policy'
require_relative 'grant-front/diagram'
require_relative 'grant-front/engine'

module GrantFront
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def mock!
      alias_method :keep_grant, :grant
      alias_method :grant, :mock_grant
    end

    def unmock!
      return unless method_defined? :mock_grant
      alias_method :grant, :keep_grant
    end
  end

  private
    def grant(*roles)
      roles.each do |role|
        return true if user.roles.include? role
      end
      return false
    end

    def mock_grant(*roles)
      roles
    end
end

require_relative 'grant-front/rails' if defined? Rails::Railtie
