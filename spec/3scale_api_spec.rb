require "spec_helper"

describe Threescale do

  describe "Instantiate 3scale object" do
    it "should raise an error when configuration variables are nil and you instantiate" do
      lambda do
        Threescale::API.new
      end.should raise_error
    end
    it "should raise an error when base_url variable is set and you instantiate obj" do
      lambda do
        Threescale.configure do |config|
          config.base_url = "https://example.com"
        end
        Threescale::API.new
      end.should raise_error
    end
    it "should not raise an error when there is one env variables and you instantiate" do
      lambda do
        Threescale.configure do |config|
          config.base_url = "https://example.com"
        end
        Threescale::API.new "provider-key"
      end.should_not raise_error
    end
    it "should not raise an error when both env variables and you instantiate" do
      lambda do
        Threescale.configure do |config|
          config.provider_key = "provider-key"
          config.base_url = "https://example.com"
        end
        Threescale::API.new
      end.should_not raise_error
    end
  end

end

describe Threescale::API do

  before(:all) do
    Threescale.configure do |config|
      config.provider_key = "provider-key"
      config.base_url = "http://test-url.test"
    end
  end

  describe "API methods" do
    before(:all) do
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

    describe "create_user" do
      it "should call /admin/api/accounts/{account_id}/users.xml" do
        stub_request(:post, "http://test-url.test/admin/api/accounts/account-id/users.xml").
            with(:body => {"email"=>"email", "password"=>"password", "provider_key"=>"provider-key", "username"=>"username"},
                 :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.9.1'}).
            to_return(:status => 200, :body => "", :headers => {})

        @threescale.create_user "account-id", "email", 'password', 'username'
      end
    end

    describe "activate_user" do
      it "should call /admin/api/accounts/{account_id}/users/{user_id}/activate.xml" do
        stub_request(:put, "http://test-url.test/admin/api/accounts/account-id/users/user-id/activate.xml").
            with(:body => {"provider_key"=>"provider-key"},
                 :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.9.1'}).
            to_return(:status => 200, :body => "", :headers => {})

        @threescale.activate_user "account-id", "user-id"
      end
    end

    describe "change_role_to_admin" do
      it "should call /admin/api/accounts/{account_id}/users/{user_id}/admin.xml" do
        stub_request(:put, "http://test-url.test/admin/api/accounts/account-id/users/user-id/admin.xml").
            with(:body => {"provider_key"=>"provider-key"},
                 :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.9.1'}).
            to_return(:status => 200, :body => "", :headers => {})

        @threescale.change_role_to_admin "account-id", "user-id"
      end
    end

    describe "change_role_to_member" do
      it "should call /admin/api/accounts/{account_id}/users/{user_id}/member.xml" do
        stub_request(:put, "http://test-url.test/admin/api/accounts/account-id/users/user-id/member.xml").
            with(:body => {"provider_key"=>"provider-key"},
                 :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.9.1'}).
            to_return(:status => 200, :body => "", :headers => {})

        @threescale.change_role_to_member "account-id", "user-id"
      end
    end

    describe "approve_account" do
      it "should call /admin/api/accounts/{account_id}/users/{user_id}/member.xml" do
        stub_request(:put, "http://test-url.test/admin/api/accounts/account_id/approve.xml").
            with(:body => {"provider_key"=>"provider-key"},
                 :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.9.1'}).
            to_return(:status => 200, :body => "", :headers => {})

        @threescale.approve_account "account_id"
      end
    end

    describe "signup_express" do
      it "should call admin/api/accounts/account_id/approve.xml" do
        stub_request(:post, "http://test-url.test/admin/api/signup.xml").
            with(:body => {"email"=>"email", "optional"=>"optional", "org_name"=>"org-name", "password"=>"password", "provider_key"=>"provider-key", "username"=>"username"},
                 :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.9.1'}).
            to_return(:status => 200, :body => "", :headers => {})

        @threescale.signup_express  "email", "org-name", "password", "username", {:optional => 'optional'}
      end
    end

    describe "get_account_plans" do
      it "should call /admin/api/account_plans.xml" do
        stub_request(:get, "http://test-url.test/admin/api/account_plans.xml?provider_key=provider-key").
            with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Faraday v0.9.1'}).
            to_return(:status => 200, :body => "", :headers => {})

        @threescale.get_account_plans
      end
    end

    describe "load_application_data" do
      it "should call /admin/api/accounts/{account_id}/applications/{application_id}.xml" do
        stub_request(:get, "http://test-url.test/admin/api/accounts/account-id/applications/application-id.xml?provider_key=provider-key").
            with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Faraday v0.9.1'}).
            to_return(:status => 200, :body => "", :headers => {})
        @threescale.load_application_data "account-id", "application-id"
      end
    end
  end
end
