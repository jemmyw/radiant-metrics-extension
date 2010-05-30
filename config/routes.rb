ActionController::Routing::Routes.draw do |map|
  map.namespace :admin do |admin|
    admin.namespace :metrics do |metrics|
      metrics.resources :metrics, :name_prefix => 'admin_'
      metrics.resources :ab_tests, :name_prefix => 'admin_'
    end
  end

  map.vanity '/admin/metrics/dashboard/:action/:id', :controller => 'vanity'
  map.track '/metrics/track/:id.:format', :controller => 'admin/metrics/metrics', :action => 'track'
end