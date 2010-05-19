require File.dirname(__FILE__) + '/../spec_helper'

describe VanityController do
  it 'should include Metrics::Identity' do
    @controller.should be_a(Metrics::Identity)
  end

  it 'should include Vanity::Rails::Dashboard' do
    @controller.should be_a(Vanity::Rails::Dashboard)
  end
end