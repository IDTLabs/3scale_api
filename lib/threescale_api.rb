require "threescale_api/version"

module Threescale
  class API
    attr_accessor :providerKey, :url, :path
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
    end
  end
end
