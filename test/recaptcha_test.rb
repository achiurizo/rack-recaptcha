require File.expand_path(File.join(File.dirname(__FILE__),'teststrap'))
require 'fakeweb'

FakeWeb.allow_net_connect = false
context "Rack::Recaptcha" do

  context "basic request" do
    setup { get("/")}
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

    context "post pass" do
      setup do
        FakeWeb.register_uri(:post, Rack::Recaptcha::VERIFY_URL, :body => "true\nsuccess")
        post("/login", 'recaptcha_challenge_field' => 'challenge', 'recaptcha_response_field' => 'response')
      end
      asserts("post login") { last_response.body }.equals 'post login'
    end

    context "post fail" do
      setup do
        FakeWeb.register_uri(:post, Rack::Recaptcha::VERIFY_URL, :body => "false\nfailed")
        post("/login", 'recaptcha_challenge_field' => 'challenge', 'recaptcha_response_field' => 'response')
      end
      asserts("post fail") { last_response.body }.equals 'post fail'
    end
  end

end
