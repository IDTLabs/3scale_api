require "threescale_api/version"
require 'faraday'

module Threescale
  class API
    attr_accessor :providerKey, :url, :path, :conn
    def initialize(providerKey = nil, debug = false)
      if ENV['THREESCALE_URL']
        @url = ENV['THREESCALE_URL']
      else
        raise Error, "Please set your 3 Scale URL as an environmental variable THREESCALE_URL"
      end
      if not providerKey
        if ENV['THREESCALE_PROVIDER_KEY']
          providerKey = ENV['THREESCALE_PROVIDER_KEY']
        end
        raise Error, "You must provide a 3 Scale provider key" if not providerKey
        @providerKey = providerKey
      end
      @conn = Faraday.new(url = @url) do | faraday|
        faraday.request :url_encoded
        faraday.response :logger
        faraday.adapter Faraday.default_adapter
      end
    end
    def getAccounts
      response = @conn.get '/admin/api/features.xml', {:provider_key => @providerKey}
      p "Here is the response: " + response.body
    end
  end
end
