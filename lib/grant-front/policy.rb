module GrantFront
  class Policy
    class << self
      def all(options={})
        options[:rake] = true if options[:rake].nil?

        if defined? Rails
          path = Rails.root.join('app/policies/*.rb').to_s
          constants = Dir.glob(path).inject([]) do |arr, item|
            require item if options[:rake]
            name = File.basename(item, '.*')
            unless name == 'application_policy'
              arr << Object.const_get(name.camelize)
            end
            arr
          end
        end

        if options[:rake]
          constants = Object.constants.inject([]) do |arr, name|
            unless name == :Config
              klass = Object.const_get(name)
              if klass.class == Class && klass.superclass == ApplicationPolicy
                arr << klass
              end
            end
            arr
          end
        end

        constants
      end

      def find(klass=nil)
        raw = {methods: {}, roles: []}
        reg = Regexp.new(/\?$/)
        user = Struct.new(:id, :roles).new(1, [])

        klass.mock!
        policy = klass.new(user, user)
        policy.methods.each do |name|
          if name =~ reg
            owner = policy.method(name).owner
            if owner == klass or owner == ApplicationPolicy
              roles = policy.send(name)
              roles ||= []
              raw[:methods][name.to_s.gsub(reg, '').to_sym] = roles
              raw[:roles] += roles
              raw[:roles].uniq!
            end
          end
        end
        klass.unmock!

        raw
      end
    end
  end
end
