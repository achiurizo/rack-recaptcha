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
      if request.post? and request.path == options[:path]
        
      end
      status, headers, body = @app.call env
      [status, headers, body]
    end
    
    def method_name
      
    end
    
  end
end