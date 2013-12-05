require "unicorn"
require "unicorn/rails/version"

module Rack
  module Handler
    class Unicorn
      class << self
        def run(app, options = {})
          unicorn_options = {}
          unicorn_options[:listeners] = options.values_at(:Host, :Port).join(':')
          unicorn_options[:pid] = options[:Pid] if options[:pid]
          unicorn_options[:worker_processes] = ENV['WORKERS'].to_i if ENV['WORKERS']

          if ::File.exist?("config/unicorn/#{environment}.rb")
            unicorn_options[:config_file] = "config/unicorn/#{environment}.rb"
          end

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
