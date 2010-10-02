# Uncomment this if you reference any of your controllers in activate
require_dependency 'application_controller'

class MetricsExtension < Radiant::Extension
  version "1.1.1"
  description "Metrics for Radiant"
  url "http://github.com/jemmyw/radiant-metrics-extension"

  extension_config do |config|
    config.gem 'vanity', :version => '1.4.0'

    if RAILS_ENV == 'test'
      config.gem 'rspec-rails', :lib => false
      config.gem 'rspec', :lib => false
      config.gem 'remarkable', :lib => false
      config.gem 'remarkable_activerecord', :lib => false
      config.gem 'remarkable_rails', :lib => false
    end
  end

  def activate
    require 'lib/metrics_playground'
    require 'lib/metrics_vanity'
    require 'lib/metrics_identity'

    Page.send :include, Metrics::Identity
    Page.send :include, MetricTags

    tab "Metrics" do
      add_item "Dashboard", "/admin/metrics/dashboard/index"
      add_item "Metrics", "/admin/metrics/metrics"
      add_item "A/B Tests", "/admin/metrics/ab_tests"
    end
    
    AbTestPage
    
    admin.page.edit.add :layout_row, 'admin/pages/ab_page_form'
  end

  def deactivate
  end

end

SiteController unless defined? SiteController

class SiteController
  def set_cache_control_with_ab_page
    if @page && @page.is_a?(AbTestPage) &&
      (request.head? || request.get?) && @page.cache?
      expires_in self.class.cache_timeout, :public => false, :private => true
    else
      set_cache_control_without_ab_page
    end
  end

  alias_method_chain :set_cache_control, :ab_page
end
