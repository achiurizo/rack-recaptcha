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
        request.params['recaptcha_msg'] = verify(request.params).to_s
      end
      @app.call(request.env)
    end

    private

    def verify(params={})
      params['recaptcha_challenge_field'] == '1'
    end

  end
end
