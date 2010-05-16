module Metrics
  module Vanity
    def create_vanity_playground
      adapter = Radiant::Config['metrics.adapter'] || 'active_record'
      ::Vanity.playground = Metrics::Playground.new(:adapter => adapter)
    end

    def create_vanity_table
      begin
        ::Vanity.playground.redis.create_table!
      rescue Exception => e
        puts "Vanity table could not be created: #{e.to_s}"
      end
    end

    def load_vanity_gem
      unless defined?(::Vanity)
        unless Radiant::Config['metrics.use_gem']
          $: << File.join(File.dirname(__FILE__), 'vanity', 'lib')
        end

        require 'vanity'
        require 'metrics_playground'
      end
    end

    def load_vanity_metrics(create_table = false)
      load_vanity_gem

      unless ::Vanity.playground.is_a?(Metrics::Playground)
        create_vanity_playground
        create_vanity_table if create_table
        ::Vanity.playground.load!
      end
    end

    module_function :create_vanity_playground
    module_function :create_vanity_table
    module_function :load_vanity_gem
    module_function :load_vanity_metrics
  end
end

ApplicationController.class_eval do
  include Metrics::Vanity
  prepend_before_filter :load_vanity_metrics
end

Metrics::Vanity.load_vanity_metrics(true)