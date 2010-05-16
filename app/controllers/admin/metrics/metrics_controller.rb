module Admin::Metrics
  class MetricsController < Admin::ResourceController
    model_class 'db_metric'

    def track
      id = params[:id].to_sym
      Vanity.playground.track! id

      respond_to do |format|
        format.js { render :json => true }
        format.json { render :json => true }
        format.html { render :nothing => true }
      end
    end
  end
end