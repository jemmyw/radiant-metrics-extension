# Uncomment this if you reference any of your controllers in activate
require_dependency 'application_controller'

class MetricsExtension < Radiant::Extension
  version "1.0"
  description "Metrics for Radiant"
  url "http://github.com/jemmyw/radiant-metrics-extension"

  extension_config do |config|
    config.gem 'rspec-rails', :lib => false
    config.gem 'rspec', :lib => false
    config.gem 'remarkable', :lib => false
    config.gem 'remarkable_activerecord', :lib => false
    config.gem 'remarkable_rails', :lib => false
  end

  def activate
    require 'vanity'
    require 'lib/metrics_playground'

    ApplicationController.class_eval do
      prepend_before_filter :load_vanity_metrics

      def load_vanity_metrics
        unless Vanity.playground
          Vanity.playground = Metrics::Playground.new(
                  :adapter => 'active_record'
          )
          Vanity.playground.load!
        end
      end
    end

    Vanity.playground = Metrics::Playground.new(
            :adapter => 'active_record'
    )
    begin
      Vanity.playground.redis.create_table!
    rescue Exception => e
      puts "Vanity table could not be created: #{e.to_s}"
    end
    Vanity.playground.load!

    Page.send :include, MetricTags

    tab "Metrics" do
      add_item "Dashboard", "/admin/metrics/dashboard/index"
      add_item "Metrics", "/admin/metrics/metrics"
      add_item "A/B Tests", "/admin/metrics/ab_tests"
    end
  end

  def deactivate
#    admin.tabs.remove "Metrics"
  end

end
