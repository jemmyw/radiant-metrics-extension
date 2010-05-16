require File.dirname(__FILE__) + '/../spec_helper'

describe DbMetric do
  before(:each) do
    @db_metric = DbMetric.new
  end

  it "should be valid" do
    @db_metric.should be_valid
  end
end
