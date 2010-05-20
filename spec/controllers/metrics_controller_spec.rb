require File.dirname(__FILE__) + '/../spec_helper'

describe Admin::Metrics::MetricsController do
  it 'should include Metrics::Identity' do
    @controller.should be_a(Metrics::Identity)
  end

  describe '#track' do
    before do
      Vanity.playground.stub!(:track!)
    end

    it 'should call track! for the given metric' do
      Vanity.playground.should_receive(:track!).with(:signup)
      get :track, :id => 'signup'
    end

    context 'json' do
      before { get :track, :id => 'signup', :format => 'json' }
      its(:response) { should be_success }
    end

    context 'html' do
      context 'no destination' do
        before { get :track, :id => 'signup', :format => 'html' }
        its(:response) { should be_success }
      end

      context 'destination specified' do
        before { get :track, :id => 'signup', :format => 'html', :destination => 'http://example.com' }
        its(:response) { should redirect_to 'http://example.com' }
      end
    end
  end
end