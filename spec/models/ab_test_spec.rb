require File.dirname(__FILE__) + '/../spec_helper'

describe AbTest do
  should_belong_to :metric
  should_validate_presence_of :name
  should_validate_presence_of :metric

  describe '::load_all' do
    before do
      @ab_1 = mock(:ab_test)
      @ab_2 = mock(:ab_test)
      AbTest.stub!(:all).and_return([@ab_1, @ab_2])
    end

    it 'should call load on all ab_tests' do
      @ab_1.should_receive(:load)
      @ab_2.should_receive(:load)
      AbTest.load_all
    end
  end

  describe '::available_metrics' do
    it 'should return all the DbMetrics' do
      @db = DbMetric.new
      DbMetric.should_receive(:all).and_return([@db])
      AbTest.available_metrics.should == [@db]
    end
  end

  describe '#load' do
    before do
      @ab_test = AbTest.new(:name => 'test')
      @experiment = mock(:experiment, :save => true)
      @ab_test.stub!(:experiment).and_return(@experiment)
      @ab_test.stub!(:new_record?).and_return(false)
      Vanity.playground.experiments.stub!(:[]=)
    end

    after { @ab_test.load }

    it 'should save the experiment' do
      @experiment.should_receive(:save)
    end

    it 'should add the experiment to the playground' do
      Vanity.playground.experiments.should_receive(:[]=).with(:test, @experiment)
    end
  end

  describe '#experiment_id' do
    before { @ab_test = AbTest.new }
    subject { @ab_test.experiment_id }

    context 'new record' do
      before { @ab_test.stub!(:new_record?).and_return(true) }
      it { should be_nil }
    end

    context 'existing record' do
      before { @ab_test.stub!(:new_record?).and_return(false) }

      context 'single word' do
        before { @ab_test.name = 'test' }
        it { should == :test }
      end

      context 'word starting with capital' do
        before { @ab_test.name = 'Test' }
        it { should == :test }
      end

      context 'two words' do
        before { @ab_test.name = 'test ab_test' }
        it { should == :test_ab_test }
      end
    end
  end
end
