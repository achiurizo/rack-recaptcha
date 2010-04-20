require 'httparty'

module Rack
  class Recaptcha
    attr_reader :options
    
    def initialize(app,options = {})
      @app, @options = app,options
    end
    
    def call(env)
      status, headers, body = @app.call env
      [status, headers, body]
    end
    
  end
end