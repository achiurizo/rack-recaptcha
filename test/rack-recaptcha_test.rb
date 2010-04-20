require File.expand_path(File.join(File.dirname(__FILE__),'teststrap'))

context "Rack::Recaptcha" do
  setup do
    @app = lambda { |env| [200, { 'Content-Type' => 'text/plain'},'hello world'] }
    PUBLIC_KEY = '0'*40
    PRIVATE_KEY = 'X'*40
  end

  context "basic request" do
    setup do
      app = Rack::Recaptcha.new @app, {}
      status, headers, body = app.call Rack::MockRequest.env_for('/')
    end
    asserts("status is 200") { topic.first }.equals 200
    asserts("body is hello world") { topic.last }.equals 'hello world'
  end
end
