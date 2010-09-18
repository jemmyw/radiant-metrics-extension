require File.dirname(__FILE__) + '/../spec_helper'

describe AbTestPage do
  dataset :pages

  before do
    @ab_test = AbTest.new(:name => 'ab')
    @experiment = mock(:experiment, :choose => false)
    @ab_test.stub!(:experiment).and_return(@experiment)
    AbTest.stub!(:find).and_return(@ab_test)
    @page = AbTestPage.new(page_params)
    @page.ab_test_id = 1
  end

  describe '#cache?' do
    subject { @page.cache? }
    it { should be_false }
  end

  describe '#process' do
    before do
      @request = mock(:request)
      @response = mock(:response)
      @return = mock(:return)
      @chosen = mock(:chosen, :process => @return)
      @page.stub!(:choose).and_return(@chosen)
    end

    subject { @page.process(@request, @response) }

    it 'should set the request' do
      subject
      @page.request.should == @request
    end

    it 'should set the response' do
      subject
      @page.response.should == @response
    end

    it 'should return the chosen processed page' do
      should == @return
    end
  end

  describe '#choose' do
    before do
      @page_a = mock(:page_a)
      @page_b = mock(:page_b)
      @page.stub!(:experiment).and_return(@experiment)
      @page.stub!(:page_a).and_return(@page_a)
      @page.stub!(:page_b).and_return(@page_b)
    end
    subject { @page.choose }

    it 'should set the vanity context' do
      Vanity.should_receive(:context=).with(@page)
      subject
    end

    context 'experiment chooses true' do
      before { @experiment.stub!(:choose).and_return(true) }
      it { should == @page_b }
    end

    context 'experiment chooses false' do
      it { should == @page_a }
    end
  end

  describe '#experiment' do
    it 'should return the ab_test experiment' do
      AbTest.should_receive(:find).with(1).and_return(@ab_test)
      @page.experiment.should == @experiment
    end
  end

  describe '#page_a' do
    it 'should return the first published child' do
      @page_a = mock(:page_a)
      @page.children.should_receive(:find).with(:first, :conditions => {:status_id => Status[:published].id}).and_return(@page_a)
      @page.page_a.should == @page_a
    end
  end

  describe '#page_b' do
    it 'should return the second published child' do
      @page_b = mock(:page_b)
      @page.children.should_receive(:find).with(:first, :offset => 1, :conditions => {:status_id => Status[:published].id}).and_return(@page_b)
      @page.page_b.should == @page_b
    end
  end
end
