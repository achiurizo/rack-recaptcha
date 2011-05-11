require  File.expand_path '../recaptcha/helpers', __FILE__
require 'net/http'

module Rack
  class Recaptcha
    API_URL         = 'http://www.google.com/recaptcha/api'
    API_SECURE_URL  = 'https://www.google.com/recaptcha/api'
    VERIFY_URL      = 'http://www.google.com/recaptcha/api/verify'
    CHALLENGE_FIELD = 'recaptcha_challenge_field'
    RESPONSE_FIELD  = 'recaptcha_response_field'

    class << self
      attr_accessor :private_key, :public_key, :test_mode

      def test_mode!(options = {})
        value = options[:return]
        self.test_mode = value.nil? ? true : options[:return]
      end
    end

    # Initialize the Rack Middleware. Some of the available options are:
    #   :public_key  -- your ReCaptcha API public key *(required)*
    #   :private_key -- your ReCaptcha API private key *(required)*
    #
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
      if request.params[CHALLENGE_FIELD] and request.params[RESPONSE_FIELD]
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
