require "3scale_api/3scale/api"
require "3scale_api/configuration"
module Threescale
  class << self
    attr_writer :configuration
  end
  def self.configuration
    @configuration ||= Configuration.new
  end
  def self.reset
    @configuration = Configuration.new
  end
  def self.configure
    yield(configuration)
  end
end