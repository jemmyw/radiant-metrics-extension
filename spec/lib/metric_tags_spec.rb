require File.dirname(__FILE__) + '/../spec_helper'

describe "MetricTags" do
  before do
    @page = Page.new
  end

  def render_tag(tag)
    @part = PagePart.new(:name => "body", :content => tag)
    @page.parts << @part
    @page.render
  end

  subject { render_tag(@tag) }

  describe '<r:track>' do
    before do
      @metric = mock(:db_metric, :experiment_id => :signup)
      DbMetric.stub!(:find_by_name).and_return(@metric)
      Vanity.playground.stub!(:track!)
      @tag = '<r:track name="Signup" />'
    end

    it { should == '' }

    it 'should turn off page caching' do
      @page.cache?.should be_true
      subject
      @page.cache?.should be_false
    end

    it 'should find the DbMetric by name' do
      DbMetric.should_receive(:find_by_name).with('Signup').and_return(@metric)
      subject
    end

    it 'should call Vanity.playground.track! passing the attribute name' do
      Vanity.playground.should_receive(:track!).with(:signup)
      subject
    end
  end

  describe '<r:ab>' do
    before do
      @tag = '<r:ab />'
    end

    it { should == '' }

    it 'should turn off page caching' do
      @page.cache?.should be_true
      subject
      @page.cache?.should be_false
    end
  end

  describe '<r:ab:test>' do
    before do
      @tag = '<r:ab:test name="homepage test">hello</r:ab:test>'
      @ab_test = mock(:ab_test, :experiment_id => :homepage_test)
      AbTest.stub!(:find_by_name).and_return(nil)
    end

    it 'should find the AbTest by attribute name' do
      AbTest.should_receive(:find_by_name).with('homepage test').and_return(@ab_test)
      subject
    end

    context 'AbTest was found' do
      before { AbTest.stub!(:find_by_name).and_return(@ab_test) }
      it { should == 'hello' }
    end

    context 'AbTest was not found' do
      it { should == '' }
    end
  end

  describe '<r:ab:test:a> and <r:ab:test:b>' do
    before do
      @tag = '<r:ab:test name="homepage test"><r:a>A!</r:a><r:b>B!</r:b></r:ab:test>'
      @ab_test = mock(:ab_test, :experiment_id => :homepage_test)
      @experiment = mock(:experiment)
      @experiment.stub!(:choose).and_return(false)
      AbTest.stub!(:find_by_name).and_return(@ab_test)
      Vanity.playground.experiments.stub!(:[]).and_return(@experiment)
    end

    it 'should retrieve the experiment by experiment_id for both <a> and <b>' do
      Vanity.playground.experiments.should_receive(:[]).twice.with(:homepage_test).and_return(@experiment)
      subject
    end

    context 'experiment.choose returns true' do
      before { @experiment.stub!(:choose).and_return(true) }
      it { should == 'B!' }
    end

    context 'experiment.choose returns false' do
      before { @experiment.stub!(:choose).and_return(false) }
      it { should == 'A!' }
    end
  end
end