module Admin::Metrics
  class MetricsController < ApplicationController
    def index
      @metrics = DbMetric.find(:all)
    end

    def new
      @metric = DbMetric.new
    end

    def create
      @metric = DbMetric.new(params[:db_metric])

      if @metric.save
        redirect_to admin_metrics_url
      else
        render :action => 'new'
      end
    end

    def edit
      @metric = DbMetric.find(params[:id])
    end

    def update
      @metric = DbMetric.find(params[:id])

      if @metric.update_attributes(params[:db_metric])
        redirect_to admin_metrics_url
      else
        render :action => 'edit', :id => @metric.id
      end
    end

    def destroy
      @metric = DbMetric.find(params[:id])
      @metric.destroy
      redirect_to admin_metrics_url
    end

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