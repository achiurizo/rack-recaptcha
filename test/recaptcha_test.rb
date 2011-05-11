require File.expand_path '../teststrap', __FILE__

FakeWeb.allow_net_connect = false
context "Rack::Recaptcha" do

  context "basic request" do
    setup { get("/") ; last_response }

    asserts(:status).equals 200
    asserts(:body).equals "Hello world"
  end

  context "exposes" do
    setup { Rack::Recaptcha }

    asserts(:private_key).equals PRIVATE_KEY
    asserts(:public_key).equals PUBLIC_KEY
  end

  context "login path" do

    asserts "GET login" do
      get '/login'
      last_response.body
    end.equals 'login'


    asserts "POST login passes and" do
      FakeWeb.register_uri(:post, Rack::Recaptcha::VERIFY_URL, :body => "true\nsuccess")
      post("/login", 'recaptcha_challenge_field' => 'challenge', 'recaptcha_response_field' => 'response')
      last_response.body
    end.equals 'post login'

    asserts "POST login fails and" do
      FakeWeb.register_uri(:post, Rack::Recaptcha::VERIFY_URL, :body => "false\nfailed")
      post("/login", 'recaptcha_challenge_field' => 'challenge', 'recaptcha_response_field' => 'response')
      last_response.body
    end.equals 'post fail'
  end

end
