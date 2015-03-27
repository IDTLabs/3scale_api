require 'spec_helper'

describe ThreescaleApi do
  before(:all) do
    ENV['THREESCALE_URL'] = nil
    ENV['THREESCALE_PROVIDER_KEY'] = nil
  end
  it "should raise an error when there is no env variables and you instantiate" do
    lambda do
      Threescale::API.new
    end.should raise_error
  end
  it "should raise an error when there is no env variables and you instantiate obj" do
    lambda do
      ENV['THREESCALE_URL'] = 'test-url'
      Threescale::API.new
    end.should raise_error
  end
  it "should not raise an error when there is one env variables and you instantiate" do
    lambda do
      ENV['THREESCALE_URL'] = 'test-url'
      Threescale::API.new 'provider-key'
    end.should_not raise_error
  end
  it "should not raise an error when both env variables and you instantiate" do
    lambda do
      ENV['THREESCALE_URL'] = 'test-url'
      ENV['THREESCALE_PROVIDER_KEY'] = 'provider-key'
      Threescale::API.new
    end.should_not raise_error
  end
end