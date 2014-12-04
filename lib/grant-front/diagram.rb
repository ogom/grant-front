module GrantFront
  class Diagram
    class << self
      def draw(options={})
        puts self.new(options).create
      end
    end

    def initialize(options={})
      @options = options
    end

    def create
      policies = {}
      GrantFront::Policy.all(@options).each do |klass|
        policies[klass.to_s.to_sym]  = GrantFront::Policy.find(klass)
      end

      text = ''
      policies.keys.each do |policy|
        text += "\n### #{policy.to_s.gsub(/Policy$/, '')} \n\n"
        if policies[policy][:roles].count > 0
          text += "||#{policies[policy][:roles].join('|')}|\n"
          text += "|:-:|#{policies[policy][:roles].map{':-:'}.join('|')}|\n"
          policies[policy][:methods].keys.each do |method|
            raw = "|#{method}|"
            policies[policy][:roles].each do |role|
              raw += 'o' if policies[policy][:methods][method].include?(role)
              raw += '|'
            end
            text += "#{raw}\n"
          end
        else
          text += "* no policy\n"
        end
      end
      text
    end
  end
end
