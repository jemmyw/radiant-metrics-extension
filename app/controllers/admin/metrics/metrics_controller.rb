module Admin::Metrics
  class MetricsController < Admin::ResourceController
    only_allow_access_to :index, :show, :new, :create, :edit, :update, :destroy,
                         :when => :admin,
                         :denied_url => {:controller => 'pages', :action => 'index'},
                         :denied_message => 'You must have administrative privileges to perform this action.'
    skip_before_filter :authenticate, :only => 'track'
    skip_before_filter :authorize, :only => 'track'

    model_class 'db_metric'

    use_vanity
    include Metrics::Identity

    # Use this action to track a metric.
    def track
      @db_metric = DbMetric.find_by_name(params[:id])
      Vanity.playground.track! @db_metric.experiment_id

      respond_to do |format|
        format.js { render :json => true }
        format.json { render :json => true }
        format.html do
          if params[:destination]
            redirect_to params[:destination]
          else
            render :nothing => true
          end
        end
      end
    end
  end
end