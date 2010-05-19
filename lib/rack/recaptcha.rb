require 'json'

RECAPTCHA_API_URL         = 'http://api.recaptcha.net'
RECAPTCHA_API_SECURE_URL  = 'https://api-secure.recaptcha.net'
RECAPTCHA_VERIFY_URL      = 'http://api-verify.recaptcha.net/verify'
RECAPTCHA_CHALLENGE_FIELD = 'recaptcha_challenge_field'
RECAPTCHA_RESPONSE_FIELD  = 'recaptcha_response_field'

require File.expand_path(File.join(File.dirname(__FILE__),'recaptcha','helpers'))

module Rack
  class Recaptcha
    attr_reader :options
    class << self
      attr_accessor :private_key, :public_key
    end

    def initialize(app,options = {})
      @app = app
      @paths = options[:paths] && [options[:paths]].flatten.compact
      self.class.private_key = options[:private_key]
      self.class.public_key = options[:public_key]
    end

    def call(env)
      request = Request.new(env)
      if request.params[RECAPTCHA_CHALLENGE_FIELD] and
         request.params[RECAPTCHA_RESPONSE_FIELD] and
         (not @paths or @paths.include?(request.path))
	value, msg = verify(request)
        env.merge!('recaptcha.valid' => value == 'true', 'recaptcha.msg' => msg)
      end
      @app.call(env)
    end

    def verify(request)
      params = {
        'privatekey' => Rack::Recaptcha.private_key,
        'remoteip' => request.ip,
        'challenge' => request.params[RECAPTCHA_CHALLENGE_FIELD],
        'response' =>  request.params[RECAPTCHA_RESPONSE_FIELD]
      }
      response = Net::HTTP.post_form URI.parse(RECAPTCHA_VERIFY_URL), params
      response.body.split("\n")
    end

  end
end
