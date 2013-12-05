require "unicorn"
require "unicorn/rails/version"

module Rack
  module Handler
    class Unicorn
      class << self
        def run(app, options = {})
          unicorn_options = {}
          unicorn_options[:listeners] = ["#{options[:Host]}:#{options[:Port]}"]

          if ::File.exist?("config/unicorn/#{environment}.rb")
            unicorn_options[:config_file] = "config/unicorn/#{environment}.rb"
          end

          ::Unicorn::Launcher.daemonize!(unicorn_options) if options[:daemonize]
          ::Unicorn::HttpServer.new(app, unicorn_options).start.join
        end

        def environment
          ENV['RACK_ENV'] || ENV['RAILS_ENV']
        end
      end
    end

    register "unicorn", "Rack::Handler::Unicorn"

    def self.default(options = {})
      Rack::Handler::Unicorn
    end
  end
end
