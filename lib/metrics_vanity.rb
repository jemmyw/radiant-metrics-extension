module Metrics
  module Vanity
    def create_vanity_playground
      ::Vanity.playground = Metrics::Playground.new
    end

    def load_vanity_gem
      unless defined?(::Vanity)
        require 'vanity'
        require 'metrics_playground'
      end
    end

    def load_vanity_metrics
      load_vanity_gem

      unless ::Vanity.playground.is_a?(Metrics::Playground)
        create_vanity_playground
        ::Vanity.playground.load!
      end
    end

    module_function :create_vanity_playground
    module_function :load_vanity_gem
    module_function :load_vanity_metrics
  end
end

ApplicationController.class_eval do
  include Metrics::Vanity
  prepend_before_filter :load_vanity_metrics
end

Metrics::Vanity.load_vanity_metrics