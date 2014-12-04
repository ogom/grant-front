require 'rack'
require 'kramdown'
require 'erb'
require 'pathname'

module GrantFront
  class Engine
    attr_accessor :request, :tree

    def call(env)
      @request = Rack::Request.new(env)
      text = Diagram.new(rake: false).create
      policy_tag = Kramdown::Document.new(text).to_html

      status = 200
      headers = {'Content-Type' => 'text/html'}
      body = ERB.new(application_template).result(binding)

      [status, headers, [body]]
    end

    private
    def application_template
      root_path = Pathname.new(File.expand_path('..', File.dirname(__FILE__)))
      templates_path = File.join(root_path, 'templates')
      application_layout = File.expand_path('application.html.erb', File.join(templates_path, 'layouts'))
      File.read(application_layout)
    end

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
