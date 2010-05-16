# Uncomment this if you reference any of your controllers in activate
require_dependency 'application_controller'

class MetricsExtension < Radiant::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/metrics"

  define_routes do |map|
    map.namespace :admin do |admin|
      admin.namespace :metrics do |metrics|
        metrics.resources :metrics, :name_prefix => 'admin_'
        metrics.resources :ab_tests, :name_prefix => 'admin_'
      end
    end

    map.vanity '/admin/metrics/dashboard/:action/:id', :controller => 'vanity'
    map.track '/metrics/track/:id', :controller => 'admin/metrics/metrics', :action => 'track'
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
