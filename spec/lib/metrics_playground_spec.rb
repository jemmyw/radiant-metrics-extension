require File.dirname(__FILE__) + '/../spec_helper'

describe Metrics::Playground do
  before do
    @playground = Metrics::Playground.new
  end

  describe '#load!' do
    before do
      AbTest.stub!(:load_all)
      DbMetric.stub!(:load_all)
    end

    it 'should set @experiments to {}' do
      @playground.load!
      @playground.experiments.should == {}
    end
    it 'should set @metrics to {}' do
      @playground.load!
      @playground.metrics.should == {}
    end
    it 'should call DbMetric.load_all' do
      DbMetric.should_receive(:load_all)
      @playground.load!
    end
    it 'should call AbTest.load_all' do
      AbTest.should_receive(:load_all)
      @playground.load!
    end
  end
end