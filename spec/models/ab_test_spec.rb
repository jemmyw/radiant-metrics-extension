require File.dirname(__FILE__) + '/../spec_helper'

describe AbTest do
  before(:each) do
    @ab_test = AbTest.new
  end

  it "should be valid" do
    @ab_test.should be_valid
  end
end
