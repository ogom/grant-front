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
      policies = []
      GrantFront::Policy.all(@options).each do |policy|
        if @options[:classes].nil? or @options[:classes].include?(policy.klass)
          policies << GrantFront::Policy.find(policy.klass)
        end
      end

      text = ''
      policies.each do |policy|
        text += "\n### #{policy.name}\n\n"
        if policy.roles.count > 0
          text += "||#{policy.roles.join('|')}|\n"
          text += "|:-|#{policy.roles.map{':-:'}.join('|')}|\n"
          policy.methods.keys.each do |method|
            raw = "|#{method}|"
            policy.roles.each do |role|
              raw += 'o' if policy.methods[method].include?(role)
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
