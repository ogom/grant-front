module GrantFront
  class Policy
    attr_accessor :klass, :name, :methods, :roles

    class << self
      def all(options={})
        options[:rake] = true if options[:rake].nil?

        if defined? Rails
          policies_path = Rails.root.join('app/policies/').to_s
          policie_path = Rails.root.join(policies_path, '**/*.rb').to_s
          constants = Dir.glob(policie_path).inject([]) do |arr, item|
            require item if options[:rake]
            klass = item.gsub(policies_path, '').gsub('.rb', '').camelcase
            arr << self.new(klass) unless klass == 'ApplicationPolicy'
            arr
          end
        end

        if options[:rake]
          constants = Object.constants.inject([]) do |arr, name|
            unless name == :Config
              klass = Object.const_get(name)
              if klass.class == Class && klass.superclass == ApplicationPolicy
                arr << self.new(klass)
              end
            end
            arr
          end
        end

        constants
      end

      def find(klass)
        policy = self.new(klass.to_s)
        klass = Object.const_get(klass.to_s)
        reg = Regexp.new(/\?$/)
        user = Struct.new(:id, :roles).new(1, [])

        klass.mock!
        klass_policy = klass.new(user, user)
        klass_policy.methods.each do |name|
          if name =~ reg
            owner = klass_policy.method(name).owner
            if owner == klass or owner == ApplicationPolicy
              roles = klass_policy.send(name)
              roles ||= []
              policy.methods[name.to_s.gsub(reg, '').to_sym] = roles
              policy.roles += roles
            end
          end
        end
        klass.unmock!

        policy.roles.uniq!
        policy
      end
    end

    def initialize(klass)
      @klass = klass.to_s
      @name = @klass.gsub(/Policy$/, '')
      @methods = {}
      @roles = []
    end

    def urn
      self.name.downcase
    end
  end
end
