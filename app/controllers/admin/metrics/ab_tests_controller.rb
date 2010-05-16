module Admin::Metrics
  class AbTestsController < Admin::ResourceController
    def index
      @ab_tests = AbTest.find(:all)
    end

    def edit
      @ab_test = AbTest.find(params[:id])
    end

    def update
      @ab_test = AbTest.find(params[:id])

      if @ab_test.update_attributes(params[:ab_test])
        redirect_to admin_ab_tests_url
      else
        render :action => 'edit'
      end
    end

    def destroy
      @ab_test = AbTest.find(params[:id])
      @ab_test.destroy
      redirect_to admin_ab_tests_url
    end
  end
end