require File.dirname(__FILE__) + '/../spec_helper'

describe Admin::Metrics::MetricsController do
  it 'should include Metrics::Identity' do
    @controller.should be_a(Metrics::Identity)
  end

  describe '#track' do
    before do
      @db_metric = mock(:db_metric, :metric_id => :signup)
      DbMetric.stub!(:find_by_name).and_return(@db_metric)
      
      Vanity.playground.stub!(:track!)
    end

    it 'should find the metric by name' do
      DbMetric.should_receive(:find_by_name).with('Signup').and_return(@db_metric)
      get :track, :id => 'Signup'
    end

    it 'should call track! for the given metric' do
      Vanity.playground.should_receive(:track!).with(:signup)
      get :track, :id => 'Signup'
    end

    context 'json' do
      before { get :track, :id => 'Signup', :format => 'json' }
      its(:response) { should be_success }
    end

    context 'html' do
      context 'no destination' do
        before { get :track, :id => 'Signup', :format => 'html' }
        its(:response) { should be_success }
      end

      context 'destination specified' do
        before { get :track, :id => 'Signup', :format => 'html', :destination => 'http://example.com' }
        its(:response) { should redirect_to 'http://example.com' }
      end
    end
  end
end