require 'json'
require 'rack/recaptcha/helpers'

module Rack
  class Recaptcha
    API_URL         = 'http://api.recaptcha.net'
    API_SECURE_URL  = 'https://api-secure.recaptcha.net'
    VERIFY_URL      = 'http://api-verify.recaptcha.net/verify'
    CHALLENGE_FIELD = 'recaptcha_challenge_field'
    RESPONSE_FIELD  = 'recaptcha_response_field'

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
      dup._call(env)
    end

    def _call(env)
      request = Request.new(env)
      if request.params[CHALLENGE_FIELD] and
        request.params[RESPONSE_FIELD] and (not @paths or @paths.include?(request.path))
        value, msg = verify(
          request.ip,
          request.params[CHALLENGE_FIELD],
          request.params[RESPONSE_FIELD]
        )
        env.merge!('recaptcha.valid' => value == 'true', 'recaptcha.msg' => msg)
      end
      @app.call(env)
    end

    def verify(ip, challenge, response)
      params = {
        'privatekey' => Rack::Recaptcha.private_key,
        'remoteip'   => ip,
        'challenge'  => challenge,
        'response'   => response
      }
      response = Net::HTTP.post_form URI.parse(VERIFY_URL), params
      response.body.split("\n")
    end

  end
end
