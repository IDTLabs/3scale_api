require 'faraday'
require 'securerandom'
require 'nokogiri'

module Threescale
  class API
    attr_accessor :provider_key, :url, :path, :conn
    def initialize(provider_key = nil)
      if ENV['THREESCALE_URL']
        @url = ENV['THREESCALE_URL']
      else
        raise ("Please set your 3 Scale URL as an environmental variable THREESCALE_URL")
      end
      if not provider_key
        if ENV['THREESCALE_PROVIDER_KEY']
          provider_key = ENV['THREESCALE_PROVIDER_KEY']
        end
        raise Error, "You must provide a 3 Scale provider key" if not provider_key
      end
      @provider_key = provider_key
      @conn = Faraday.new(url = @url) do | faraday|
        faraday.request :url_encoded
        faraday.response :logger
        faraday.adapter Faraday.default_adapter
      end
    end

    def create_application(account_id, plan_id, name, description = nil)
      response = conn.post "/admin/api/accounts/#{account_id}/applications.xml", {
        :provider_key => @provider_key ,
        :name => name,
        :description => description,
        :plan_id => plan_id}
      return false if response.status != 201
      xml = Nokogiri::XML(response.body)
      result = {
          :app_id => xml.css("application application_id").text ,
          :application_id => xml.css("application id").text,
          :keys => [xml.css("application keys key").text]
      }
    end

    def delete_application_key(account_id, application_id, key)
      response = @conn.delete "/admin/api/accounts/#{account_id}/applications/#{application_id}/keys/#{key}.xml", {
      :provider_key => @provider_key }
      response.status == 200
    end

    def generate_application_key(account_id, application_id)
      new_key = SecureRandom.hex(16)
      response = conn.post "/admin/api/accounts/#{account_id}/applications/#{application_id}/keys.xml", {
                                                                                                          :provider_key => @provider_key ,
                                                                                                          :key => new_key }
      response.status == 201
    end

    def get_application_keys(account_id, application_id)
      response = @conn.get "/admin/api/accounts/#{account_id}/applications/#{application_id}/keys.xml", {
      :provider_key => @provider_key, }
      p response.status
      return [] if response.status != 200
      xml = Nokogiri::XML(response.body)
      nodes = xml.xpath('keys/key')
      nodes.css('value').map do |key|
        key.text
      end
    end

    def get_application_list(account_id)
      results = Array.new
      response = @conn.get "/admin/api/accounts/#{account_id}/applications.xml", {:provider_key => @provider_key, }
      return [] if response.status != 200
      xml = Nokogiri::XML(response.body)
      applications = xml.xpath('applications/application')
      applications.each do |application|
        keys = application.xpath("//keys/key").map do |key|
          key.text
        end
        results.push(
        {:keys => keys,
        :id => application.css('id').text,
        :name => application.css('name').text,
        :application_id => application.css('application_id').text,
        :plan_type => application.css('plan name').text,
        :service_id => application.css('service_id').first.text
        })
      end
      results
    end

    def get_service_plans
      results = Array.new
      response = @conn.get "/admin/api/application_plans.xml", {:provider_key => @provider_key }
      xml = Nokogiri::XML(response.body)
      plans = xml.xpath("//plans/plan")
      plans = plans.map do |plan|
        {
          :name => plan.css("name").text,
          :service_plan_id => plan.css("service_id").text
        }
      end
    end

    def get_services
      results = Array.new
      response = @conn.get "/admin/api/services.xml", {:provider_key => @provider_key }
      xml = Nokogiri::XML(response.body)
      services = xml.xpath("//services/service")
      services.map do |service|
        {
            :name => service.css("name").first.text,
            :service_id => service.css("id").first.text
        }
      end
    end

    # Account API methods
    def approve_account(account_id)
      response = @conn.put "/admin/api/accounts/#{account_id}/approve.xml", {
        :provider_key => @provider_key}
      response.status == 201
    end

    def signup_express( email, org_name, password, username, additional_fields = nil)
      params = {:provider_key => @provider_key, :username => username, :password => password, :email => email,
        :org_name => org_name}
      if (additional_fields)
        additional_fields.each do |key, value|
          params[key] = value
        end
      end
      response = @conn.post "/admin/api/signup.xml", params
      xml = Nokogiri::XML(response.body)
      result = {
          :success => false
      }
      if response.status == 422
        errors =  xml.xpath("//errors/error").map do |error|
          error.text
        end
        result[:errors] = errors
      end
      return result if response.status != 201
      result[:success] = true

      account_id = xml.xpath('//account/id').first.text
      user_id = xml.xpath('//account/users/user/id').text
      self.approve_account account_id
      results = self.get_application_list account_id
      results[0][:user_id] = user_id.to_s
      result[:account_info] = results
      result[:account_id] = account_id
      result
    end

    def get_account_plans
      response = @conn.get "/admin/api/account_plans.xml", {:provider_key => @provider_key}
      return false if response.status != 200
      xml = Nokogiri::XML(response.body)
      account_plans = Array.new
      xml.xpath("//plans/plan").map do |account_plan|
        if account_plan.css("state").text == "published"
          account_plans.push({
            :name => account_plan.css("name").text,
            :account_plan_id => account_plan.css("id").text
          })
        end
      end
      account_plans
    end

    def create_user(account_id, email, password, username)
      response = @conn.post "/admin/api/accounts/#{account_id}/users.xml", {:provider_key => @provider_key,
        :username => username, :password => password, :email => email}
      response.status == 201
    end

    def activate_user(account_id, user_id)
      response = @conn.put "/admin/api/accounts/#{account_id}/users/#{user_id}/activate.xml", {
        :provider_key => @provider_key}
      response.status == 201
    end

    def change_role_to_admin(account_id, user_id)
      response = @conn.put "/admin/api/accounts/#{account_id}/users/#{user_id}/admin.xml", {
        :provider_key => @provider_key}
      response.status == 201
    end

    def change_role_to_member(account_id, user_id)
      response = @conn.put "/admin/api/accounts/#{account_id}/users/#{user_id}/member.xml", {
        :provider_key => @provider_key}
      response.status == 201
    end

  end
end
