require "spec_helper"

describe "3scaleApi" do
  before(:all) do
    ENV["THREESCALE_URL"] = nil
    ENV["THREESCALE_PROVIDER_KEY"] = nil
  end

  describe "Instantiate 3scale object" do
    it "should raise an error when there is no env variables and you instantiate" do
      lambda do
        Threescale::API.new
      end.should raise_error
    end
    it "should raise an error when there is no env variables and you instantiate obj" do
      lambda do
        ENV["THREESCALE_URL"] = "test-url"
        Threescale::API.new
      end.should raise_error
    end
    it "should not raise an error when there is one env variables and you instantiate" do
      lambda do
        ENV["THREESCALE_URL"] = "test-url"
        Threescale::API.new "provider-key"
      end.should_not raise_error
    end
    it "should not raise an error when both env variables and you instantiate" do
      lambda do
        ENV["THREESCALE_URL"] = "http://test-url"
        ENV["THREESCALE_PROVIDER_KEY"] = "provider-key"
        Threescale::API.new
      end.should_not raise_error
    end
  end

  describe "API methods" do
    before(:all) do
      ENV["THREESCALE_URL"] = "http://test-url.test"
      @threescale = Threescale::API.new 'provider-key'
    end

    describe "get_application_keys" do
      it "should call /admin/api/accounts/{account_id}/applications/{application_id}/keys.xml" do
        stub_request(
          :get,
          "http://test-url.test/admin/api/accounts/account-id/applications/application-id/keys.xml?provider_key=provider-key").
            with(
              :headers => {
                'Accept'=>'*/*',
                'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'User-Agent'=>'Faraday v0.9.1'}).
            to_return(:status => 200, :body => "", :headers => {})
        @threescale.get_application_keys 'account-id', 'application-id'
      end
    end

    describe "get_application_list" do
      it "should call /admin/api/accounts/{account_id}/applications.xml" do
        stub_request(
          :get,
          "http://test-url.test/admin/api/accounts/account-id/applications.xml?provider_key=provider-key").
            with(
              :headers => {
                'Accept'=>'*/*',
                'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'User-Agent'=>'Faraday v0.9.1'}).
            to_return(:status => 200, :body => "", :headers => {})

        @threescale.get_application_list 'account-id'
      end
    end
    describe "delete_application_key" do
      it "should call /admin/api/accounts/{account_id}/applications/{application_id}/keys/{key}.xml" do
        stub_request(
          :delete,
          "http://test-url.test/admin/api/accounts/account-id/applications/application-id/keys/key.xml?provider_key=provider-key").
            with(
              :headers => {
                'Accept'=>'*/*',
                'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'User-Agent'=>'Faraday v0.9.1'}).
            to_return(:status => 200, :body => "", :headers => {})

        @threescale.delete_application_key 'account-id', 'application-id', 'key'
      end
    end
    describe "generate_application_key" do
      it "should call /admin/api/accounts/{account_id}/applications/{application_id}/keys.xml" do
        stub_request(
          :post,
          "http://test-url.test/admin/api/accounts/account-id/applications/application-id/keys.xml").
            with(
              :body => {
                "key"=>/[0-9a-f]{32}/,
                "provider_key"=>"provider-key"},
                 :headers => {
                   'Accept'=>'*/*',
                   'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                   'Content-Type'=>'application/x-www-form-urlencoded',
                   'User-Agent'=>'Faraday v0.9.1'})


        @threescale.generate_application_key 'account-id', 'application-id'
      end
    end

    describe "create_application" do
      it "should call /admin/api/accounts/{account_id}/applications.xml" do
        stub_request(
          :post,
          "http://test-url.test/admin/api/accounts/account-id/applications.xml").
            with(
              :body => {
                "description"=>"description",
                "name"=>"name",
                "plan_id"=>"plan-id",
                "provider_key"=>"provider-key"},
                 :headers => {
                   'Accept'=>'*/*',
                   'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                   'Content-Type'=>'application/x-www-form-urlencoded',
                   'User-Agent'=>'Faraday v0.9.1'}).
            to_return(:status => 200, :body => "", :headers => {})

        @threescale.create_application 'account-id', 'plan-id', 'name', 'description'
      end
    end

    describe "get_service_plans" do
      it "should call /admin/api/application_plans.xml" do
        stub_request(:get, "http://test-url.test/admin/api/application_plans.xml?provider_key=provider-key").
            with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Faraday v0.9.1'}).
            to_return(:status => 200, :body => "", :headers => {})

        @threescale.get_service_plans
      end
    end

    describe "get_services" do
      it "should call /admin/api/services.xml" do
        stub_request(:get, "http://test-url.test/admin/api/services.xml?provider_key=provider-key").
            with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Faraday v0.9.1'}).
            to_return(:status => 200, :body => "", :headers => {})
        @threescale.get_services
      end
    end

    describe "create_account" do
      it "should call /admin/api/accounts/{account_id}/applications.xml" do
        stub_request(:post, "http://test-url.test/admin/api/services/service-id/application_plans.xml").
            with(:body => {"name"=>"name", "provider_key"=>"provider-key"},
                 :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.9.1'}).
            to_return(:status => 200, :body => "", :headers => {})
        @threescale.create_account "name", "service-id"
      end
    end
  end
end
