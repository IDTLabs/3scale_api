require File.expand_path('../../spec_helper', __FILE__)
require "threescale"

module Threescale
  describe Configuration do
    describe "#provider_key" do
      it "default value is qwerty" do
        Configuration.new.provider_key = "qwerty"
      end
    end

    describe "#provider_key=" do
      it "can set value" do
        config = Configuration.new
        config.provider_key = "asdfgh"
        expect(config.provider_key).must_equal("asdfgh")
      end
    end
  end

  describe "#configure" do
    before :each do
      Threescale.configure do |config|
        config.provider_key = "qwerty"
        config.base_url = "asdfgh"
      end
    end
    it "returns the setting provider_key that equals 'qwerty'" do
      endpoints = Api::Endpoints.new
      expect(endpoints.config.base_url).must_equal "asdfgh"
      expect(endpoints.config.provider_key).must_equal "asdfgh"
    end
  end
end
