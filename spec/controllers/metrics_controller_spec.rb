require File.dirname(__FILE__) + '/../spec_helper'

describe Admin::Metrics::MetricsController do
  it 'should include Metrics::Identity' do
    @controller.should be_a(Metrics::Identity)
  end
end