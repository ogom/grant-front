module GrantFront
  class Grant
    class << self
      def draw
        policies = {}
        GrantFront::Policy.all.each do |klass|
          policies[klass.to_s.to_sym]  = GrantFront::Policy.find(klass)
        end

        policies.keys.each do |policy|
          puts "\n# #{policy} \n\n"
          puts "||#{policies[policy][:roles].join('|')}|"
          puts "|:-:|#{policies[policy][:roles].map{':-:'}.join('|')}|"
          policies[policy][:methods].keys.each do |method|
            raw = "|#{method}|"
            policies[policy][:roles].each do |role|
              raw += 'o' if policies[policy][:methods][method].include?(role)
              raw += '|'
            end
            puts raw
          end
        end
      end
    end
  end
end
