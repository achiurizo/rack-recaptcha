require File.expand_path(File.join(File.dirname(__FILE__),'teststrap'))
require 'fakeweb'

FakeWeb.allow_net_connect = false

PUBLIC_KEY = '0'*40
PRIVATE_KEY = 'X'*40

context "Rack::Recaptcha" do
  setup do
    @app ||= begin
      main_app = lambda { |env|
        request = Rack::Request.new(env)
        return_code, body_text = request.path == '/' ? [200,'Hello world'] : [404,'Nothing here']
        [return_code,{'Content-type' => 'text/plain'}, body_text]
      }
      
      builder = Rack::Builder.new
      builder.use Rack::Session::Cookie
      builder.use Rack::Recaptcha, :private_key => PRIVATE_KEY, :public_key => PUBLIC_KEY
      builder.run main_app
      builder.to_app
    end
    
  end

  context "basic request" do
    setup do
      app = Rack::Recaptcha.new @app, {}
      status, headers, body = app.call Rack::MockRequest.env_for('/')
    end
    asserts("status is 200") { topic.first }.equals 200
    asserts("body is hello world") { topic.last }.equals 'Hello world'
  end
  
  context "exposes" do
    setup { Rack::Recaptcha }
    asserts("private key") { topic.private_key }.equals PRIVATE_KEY
    asserts("public key") { topic.public_key }.equals PUBLIC_KEY
  end
  

  
  
  
end
