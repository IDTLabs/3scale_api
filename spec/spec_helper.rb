require 'rubygems'
require 'bundler/setup'
require 'minitest/autorun'
require 'webmock/rspec'
require 'webmock/rspec/matchers'
require 'webmock/rspec/matchers/request_pattern_matcher'
require 'webmock/rspec/matchers/webmock_matcher'
require '3scale_api'
require 'pry'

WebMock.disable_net_connect!(allow_localhost: true)