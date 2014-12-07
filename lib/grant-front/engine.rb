require 'rack'
require 'kramdown'
require 'erb'
require 'pathname'

module GrantFront
  class Engine
    attr_accessor :request, :tree

    def call(env)
      @request = Rack::Request.new(env)

      status = 200
      headers = {'Content-Type' => 'text/html'}
      body = ERB.new(application_template).result(binding)

      [status, headers, [body]]
    end

    private
      def policy_link_to
        "<a href=#{request.script_name}>Policy</a>"
      end

      def policies_tag
        raw = ""
        policies = GrantFront::Policy.all(rake: false)

        raw += "<div><ul>"
        raw += policies.map do |policy|
          raw = "<li"
          if '/' + policy.urn == request.path_info
            raw += " class='active'"
          end
          raw += "><a href=#{request.script_name}/#{policy.urn}>#{policy.name}</a>"
          raw += "</li>"
        end.join("\n")
        raw += "</ul></div>"

        raw
      end

      def policy_tag
        policies = GrantFront::Policy.all(rake: false)
        classes = policies.inject([]) do |arr, policy|
          arr << policy.klass if '/' + policy.urn == request.path_info
          arr
        end
        classes = nil if classes.count == 0

        text = Diagram.new(rake: false, classes: classes).create
        Kramdown::Document.new(text).to_html
      end

      def application_template
        root_path = Pathname.new(File.expand_path('..', File.dirname(__FILE__)))
        templates_path = File.join(root_path, 'templates')
        application_layout = File.expand_path('application.html.erb', File.join(templates_path, 'layouts'))
        File.read(application_layout)
      end
    # end private

    class << self
      def prototype
        @prototype ||= new
      end

      def call(env)
        prototype.call(env)
      end
    end
  end
end
