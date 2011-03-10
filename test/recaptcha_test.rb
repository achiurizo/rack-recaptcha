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
