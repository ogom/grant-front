module GrantFront
  class Policy
    class << self
      def all
        requires

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

      def find(klass=nil)
        raw = {methods: {}, roles: []}
        reg = Regexp.new(/\?$/)
        user = Struct.new(:id, :roles).new(1, [])
        ApplicationPolicy.mock!

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
        ApplicationPolicy.unmock!

        raw
      end

      private
      def requires
        if defined? Rails
          Dir.glob(Rails.root.join('app/policies/*.rb').to_s).each do |name|
            require name
          end
        end
      end
    end
  end
end
