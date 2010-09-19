require File.dirname(__FILE__) + '/../spec_helper'

describe DbMetric do
  should_validate_presence_of :name

  describe '::load_all' do
    before do
      @db_1 = mock(:metric)
      @db_2 = mock(:metric)
      DbMetric.stub!(:all).and_return([@db_1, @db_2])
    end

    it 'should call load on all ab_tests' do
      @db_1.should_receive(:load)
      @db_2.should_receive(:load)
      DbMetric.load_all
    end
  end

  describe '#load' do
    before do
      @db_metric = DbMetric.new(:name => 'test')
      @metric = mock(:metric, :save => true)
      @db_metric.stub!(:metric).and_return(@metric)
      @db_metric.stub!(:new_record?).and_return(false)
      Vanity.playground.metrics.stub!(:[]=)
    end

    after { @db_metric.load }

    it 'should add the metric to the playground' do
      Vanity.playground.metrics.should_receive(:[]=).with(:test, @metric)
    end
  end

  describe '#metric_id' do
    before { @db_metric = DbMetric.new }
    subject { @db_metric.metric_id }

    context 'new record' do
      before { @db_metric.stub!(:new_record?).and_return(true) }
      it { should be_nil }
    end

    context 'existing record' do
      before { @db_metric.stub!(:new_record?).and_return(false) }

      context 'single word' do
        before { @db_metric.name = 'test' }
        it { should == :test }
      end

      context 'word starting with capital' do
        before { @db_metric.name = 'Test' }
        it { should == :test }
      end

      context 'two words' do
        before { @db_metric.name = 'test ab_test' }
        it { should == :test_ab_test }
      end
    end
  end

  describe '#count' do
    before do
      @db_metric = DbMetric.new
      @metric = mock(:metric)
      @db_metric.stub!(:metric).and_return(@metric)
    end
    subject { @db_metric.count }
    
    context 'new record' do
      it { should == 0 }
    end

    context 'existing record' do
      before do
        @db_metric.stub!(:new_record?).and_return(false)
        @created_at = 1.day.ago
        @now = Time.now
        @db_metric.created_at = @created_at
        Time.stub!(:now).and_return(@now)
      end 

      it 'should return summed metric.values with created_at and Time.now' do
        @metric.should_receive(:values).with(@created_at, @now).and_return([1, 2, 3, 7])
        should == 13
      end
    end
  end

  describe '#after_destroy' do
    before do
      @db_metric = DbMetric.create(:name => 'test')
    end

    it 'should call Vanity.playground.reload!' do
      Vanity.playground.should_receive(:reload!)
      @db_metric.destroy
    end
  end
end
