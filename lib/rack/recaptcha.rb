require 'json'

RECAPTCHA_API_URL        = 'http://api.recaptcha.net'
RECAPTCHA_API_SECURE_URL = 'https://api-secure.recaptcha.net'
RECAPTCHA_VERIFY_URL     = 'http://api-verify.recaptcha.net/verify'

require File.expand_path(File.join(File.dirname(__FILE__),'recaptcha','helpers'))

module Rack
  class Recaptcha
    attr_reader :options
    class << self
      attr_accessor :private_key, :public_key
    end

    def initialize(app,options = {})
      @app, @options = app,options
      self.class.private_key = options[:private_key]
      self.class.public_key = options[:public_key]
    end

    def call(env)
      request = Request.new(env)
      if request.post? and request.path == @options[:login_path]
        value, msg = verify(request)
        env.merge!('recaptcha.value' => value, 'recaptcha.msg' => msg)
      end
      @app.call(env)
    end

    def verify(request)
      params = {
        :privatekey => Rack::Recaptcha.private_key,
        :remoteip => request.ip,
        :challenge => request.params['recaptcha_challenge_field'],
        :response =>  request.params['recaptcha_response_field']
      }
      response = Net::HTTP.post_form URI.parse(RECAPTCHA_VERIFY_URL), params
      response.body.split("\n")
    end

  end
end