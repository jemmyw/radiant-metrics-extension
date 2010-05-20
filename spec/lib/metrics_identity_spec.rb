require File.dirname(__FILE__) + '/../spec_helper'

describe Metrics::Identity do
  # TODO: not sure where to put this spec
  it 'should be included into the page model' do
    Page.new.should be_a(Metrics::Identity)
  end

  before do
    @object = Object.new
    @object.metaclass.send(:include, Metrics::Identity)
    @request = mock(:request, :cookies => {})
    @response = mock(:response)
  end

  describe '#vanity_cookies' do
    subject { @object.vanity_cookies }

    context 'object provides cookies' do
      before do
        @cookies = mock(:cookies)
        @object.stub!(:cookies).and_return(@cookies)
      end

      it { should == @cookies }
    end

    context 'object does not provide cookies' do
      before do
        @object.stub!(:request).and_return(@request)
        @object.stub!(:response).and_return(@response)
      end

      it { should_not be_nil }
      it { should be_a(ActionController::CookieJar) }
    end
  end

  describe '#vanity_identity' do
    before { @object.stub!(:vanity_cookies).and_return(nil) }
    subject { @object.vanity_identity }

    context 'param method is available' do
      before { @object.stub!(:params).and_return({}) }

      context 'and has vanity_id key' do
        before { @object.params[:vanity_id] = 'abc' }
        it { should == 'abc' }
      end

      context 'and has no vanity_id key' do
        context 'but does have vanity cookie' do
          before { @object.stub!(:vanity_cookies).and_return({'vanity_id' => '123'}) }
          it { should == '123' }
        end
        
        context 'and has no vanity cookie' do
          it { should be_nil }
        end
      end
    end

    context 'no cookies are available' do
      it { should be_nil }
    end

    context 'cookies are available' do
      before do
        @cookies = {}
        @object.stub!(:vanity_cookies).and_return(@cookies)
        @now = Time.now
        Time.stub!(:now).and_return(@now)
      end

      context 'cookie is already set' do
        before do
          @cookies['vanity_id'] = 'abc'
        end

        it { should == 'abc' }

        it 'should reset the expiry of the cookie' do
          subject
          @cookies['vanity_id'][:expires].should == 1.month.from_now
        end
      end

      context 'cookie is not set' do
        it { should_not be_nil }
        it { should be_a(String) }

        it 'should create a new cookie' do
          subject
          @cookies['vanity_id'][:expires].should == 1.month.from_now
        end
      end
    end
  end
end