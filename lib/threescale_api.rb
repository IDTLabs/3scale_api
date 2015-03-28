require "threescale_api/version"
require 'faraday'
require 'securerandom'
require 'nokogiri'

module Threescale
  class API
    attr_accessor :provider_key, :url, :path, :conn
    def initialize(provider_key = nil, debug = false)
      if ENV['THREESCALE_URL']
        @url = ENV['THREESCALE_URL']
      else
        raise Error, "Please set your 3 Scale URL as an environmental variable THREESCALE_URL"
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

    def get_application_keys(account_id, application_id)
      response = @conn.get "/admin/api/accounts/#{account_id}/applications/#{application_id}/keys.xml", {:provider_key => @provider_key, }
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
             :plan_type => application.css('plan name').text})
      end
      results
      end
    def delete_application_key(account_id, application_id, key)
      response = @conn.delete "/admin/api/accounts/#{account_id}/applications/#{application_id}/keys/#{key}.xml", {:provider_key => @provider_key }
      response.status == 200
    end

    def generate_application_key(account_id, application_id)
      new_key = SecureRandom.hex(16)
      response = conn.post "/admin/api/accounts/#{account_id}/applications/#{application_id}/keys.xml", {:provider_key => @provider_key , :key => new_key }
      response.status == 201
    end
    def create_application(account_id, plan_id, name, description = nil)
      response = conn.post "/admin/api/accounts/#{account_id}/applications.xml", {:provider_key => @provider_key , :name => name, :description => description, :plan_id => plan_id}
      return false if response.status != 201
      xml = Nokogiri::XML(response.body)
      result = {
          :app_id => xml.css("application application_id").text ,
          :application_id => xml.css("application id").text,
          :keys => [xml.css("application keys key").text]
      }
    end
  end
end
