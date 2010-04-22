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
      if request.post? and request.path == options[:login_path]
        request.params['rack_recaptcha_value'], request.params['rack_recaptcha_msg'] = verify(request)
      end
      @app.call(request.env)
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
