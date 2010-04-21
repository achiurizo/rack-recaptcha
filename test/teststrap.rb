require 'rubygems'
require 'rr'
require 'riot'
require 'riot/rr'
require 'rack/test'
require 'rack/mock'
require 'rack/utils'
require 'rack/session/cookie'
require 'rack/builder'
require File.expand_path(File.join(File.dirname(__FILE__),'..','lib','rack-recaptcha'))

class Rack::Situation
  include Rack::Test::Methods
end