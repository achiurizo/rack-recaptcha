require File.expand_path(File.join(File.dirname(__FILE__),'teststrap'))
require 'fakeweb'

# FakeWeb.allow_net_connect = false

PUBLIC_KEY = '0'*40
PRIVATE_KEY = 'X'*40

context "Rack::Recaptcha" do

  context "basic request" do
    setup do
      get("/")
    end
    asserts("status is 200") { last_response.status }.equals 200
    asserts("body is hello world") { last_response.body }.equals 'Hello world'
  end

  context "exposes" do
    setup { Rack::Recaptcha }
    asserts("private key") { topic.private_key }.equals PRIVATE_KEY
    asserts("public key") { topic.public_key }.equals PUBLIC_KEY
  end

  context "login path" do

    context "get" do
      setup { get('/login') }
      asserts("get login") { last_response.body }.equals 'login'
    end

    context "post fail" do
      setup do
        post("/login")
      end
      asserts("post fail") { last_response.body }.equals 'post fail'
    end
  end
  
end
