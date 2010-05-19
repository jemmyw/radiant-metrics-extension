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
    require 'lib/metrics_vanity'
    require 'lib/metrics_identity'

    Page.send :include, Metrics::Identity
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
