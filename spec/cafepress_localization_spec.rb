require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class DummyController < ApplicationController
  def index
    render :text => "dummy controller"
  end
end
 
describe "Locale and internationalization" do
  controller_name :dummy
    
  context "#detect_locale_from_query_params" do
        
    it 'should examine the en-UK locale query parameter and set the locale to en-UK' do
      get :index, :locale => "en-UK"
      I18n.locale.to_s.should == "en-UK"
    end
    
    it 'should examine the en-AU locale query parameter and set the locale to en-AU' do
      get :index, :locale => "en-AU"
      I18n.locale.to_s.should == "en-AU"
    end
    
    it 'should examine the en-CA locale query parameter and set the locale to en-CA' do
      get :index, :locale => "en-CA"
      I18n.locale.to_s.should == "en-CA"
    end
    
    it 'should examine the en-US locale query parameter and set the locale to en-US' do
      get :index, :locale => "en-US"
      I18n.locale.to_s.should == "en-US"
    end
    
  end
  
  context "#detect_locale_from_uri" do
    
    it 'should look at the uri if the query param does not exist and set the locale to en-UK' do
      request.stub!(:host).and_return("example.co.uk")
      get :index
      I18n.locale.to_s.should == "en-UK"
    end
    
    it 'should look at the uri if the query param does not exist and set the locale to en-CA' do
      request.stub!(:host).and_return("example.com.ca")
      get :index
      I18n.locale.to_s.should == "en-CA"
    end
    
    it 'should look at the uri if the query param does not exist and set the locale to en-AU' do
      request.stub!(:host).and_return("example.com.au")
      get :index
      I18n.locale.to_s.should == "en-AU"
    end
    
    it 'should look at the uri if the query param does not exist and set the locale to en-US' do
      request.stub!(:host).and_return("example.com")
      get :index
      I18n.locale.to_s.should == "en-US"
    end
    
    it 'should set the correct locale if the uri is find.co.uk.dev' do
      request.stub!(:host).and_return("find.co.uk.dev")
      get :index
      I18n.locale.to_s.should == "en-UK"
    end
    
  end
  
  context "#order of precendence for setting locale" do
  
  it 'should set the locale based on the query parameters first' do
    request.stub!(:host).and_return("example.com.ca")
    get :index , :locale => "en-UK"
    I18n.locale.to_s.should == "en-UK"
  end
  
  it 'should set the locale based on uri second' do
    request.stub!(:host).and_return("example.com.ca")
    get :index
    I18n.locale.to_s.should == "en-CA"
  end
  
  it 'should default to the en-US if nothing exists' do
    get :index
    I18n.locale.to_s.should == "en-US"
  end
  
end

context "read the configuration per locale" do
  it 'should be able to use the en-UK local config and read the region' do
    get :index, :locale => "en-UK"
    I18n.t('region').should == "uk" 
  end
  
  it 'should be able to use the en-AU local config and read the region' do
    get :index, :locale => "en-AU"
    I18n.t('region').should == "au" 
  end
  
  it 'should be able to use the en-CA local config and read the region' do
    get :index, :locale => "en-CA"
    I18n.t('region').should == "ca" 
  end 
  
  it 'should be able to use the en-US local config and read the region' do
    get :index, :locale => "en-US"
    I18n.t('region').should == "us" 
  end
end

end