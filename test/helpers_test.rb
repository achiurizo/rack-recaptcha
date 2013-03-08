require File.expand_path '../test_helper', __FILE__

class HelperTest
  attr_accessor :request
  include Rack::Recaptcha::Helpers

  def initialize
    @request = HelperTest::Request.new
  end

  class Request
    attr_accessor :env
  end
end

# With "attr_accessor :request" HelperTest has "request" defined as a method
# even when @request is set to nil
#
# defined?(request)
# => method
# request
# => nil
# self
# => #<HelperTest:0x00000002125000 @request=nil>
class HelperTestWithoutRequest
  include Rack::Recaptcha::Helpers
end

describe Rack::Recaptcha::Helpers do

  def helper_test
    HelperTest.new
  end

  def helper_test_without_request
    HelperTestWithoutRequest.new
  end

  before do
    Rack::Recaptcha.public_key = ::PUBLIC_KEY
  end

  describe ".recaptcha_tag" do

    it "should render ajax with display" do
      mock(helper_test.request.env).[]('recaptcha.msg').returns(nil)
      topic = helper_test.recaptcha_tag(:ajax,:display => {:theme => 'red'})

      assert_match %r{recaptcha_ajax.js},               topic
      assert_match %r{<div id="ajax_recaptcha"></div>}, topic
      assert_match %r{RecaptchaOptions},                topic
      assert_match %r{"theme":"red"},                   topic
    end

    it "should render ajax without display" do
      mock(helper_test.request.env).[]('recaptcha.msg').returns(nil)
      topic = helper_test.recaptcha_tag(:ajax)

      assert_match %r{recaptcha_ajax.js}, topic
      assert_match %r{<div id="ajax_recaptcha"></div>}, topic
      refute_match %r{RecaptchaOptions}, topic
      refute_match %r{"theme":"red"}, topic
    end

    it "should render noscript" do
      mock(helper_test.request.env).[]('recaptcha.msg').returns(nil)
      topic = helper_test.recaptcha_tag :noscript, :public_key => "hello_world_world", :language => :en

      assert_match %r{iframe},            topic
      assert_match %r{<noscript>},        topic
      assert_match %r{hello_world_world}, topic
      assert_match %r{hl=en},             topic
      refute_match %r{recaptcha_ajax.js}, topic
    end

    it "should render challenge" do
      mock(helper_test.request.env).[]('recaptcha.msg').returns(nil)
      topic = helper_test.recaptcha_tag(:challenge, :language => :en)

      assert_match %r{script},            topic
      assert_match %r{challenge},         topic
      refute_match %r{recaptcha_ajax.js}, topic
      refute_match %r{RecaptchaOptions},  topic
      assert_match %r{#{'0'*40}},         topic
      assert_match %r{hl=en},             topic
    end

    it "should render script with SSL URL" do
      mock(helper_test.request.env).[]('recaptcha.msg').returns(nil)
      topic = helper_test.recaptcha_tag(:challenge, :ssl => true)
      assert_match %r{#{Rack::Recaptcha::API_SECURE_URL}}, topic
    end

    it "should render script with no SSL URL" do
      mock(helper_test.request.env).[]('recaptcha.msg').returns(nil)
      topic = helper_test.recaptcha_tag(:ajax)
      assert_match %r{#{Rack::Recaptcha::API_URL}}, topic
    end
  end

  describe ".recaptcha_tag with errors" do
    it "should render challenge with error" do
      mock(helper_test.request.env).[]('recaptcha.msg').returns("Sample Error")
      topic = helper_test.recaptcha_tag(:challenge)

      assert_match %r{script},            topic
      assert_match %r{challenge},         topic
      refute_match %r{recaptcha_ajax.js}, topic
      refute_match %r{RecaptchaOptions},  topic
      assert_match %r{#{'0'*40}},         topic
      assert_match %r{Sample%20Error},    topic
    end

    it "should render noscript with error" do
      mock(helper_test.request.env).[]('recaptcha.msg').returns("Sample Error")
      topic = helper_test.recaptcha_tag :noscript, :public_key => "hello_world_world"

      assert_match %r{iframe},            topic
      assert_match %r{<noscript>},        topic
      assert_match %r{hello_world_world}, topic
      refute_match %r{recaptcha_ajax.js}, topic
      assert_match %r{Sample%20Error},    topic
    end
  end

  describe ".recaptcha_valid?" do
    it "should assert that it passes when recaptcha.valid is true" do
      Rack::Recaptcha.test_mode = nil
      mock(helper_test.request.env).[]('recaptcha.valid').returns(true)
      assert helper_test.recaptcha_valid?
    end

    it "should refute that it passes when recaptcha.valid is false" do
      Rack::Recaptcha.test_mode = nil
      mock(helper_test.request.env).[]('recaptcha.valid').returns(false)
      refute helper_test.recaptcha_valid?
    end

    it "should assert that it passes when test mode set to pass" do
      Rack::Recaptcha.test_mode!
      assert helper_test.recaptcha_valid?
    end

    it "should assert that it passes when test mode set to fail" do
      Rack::Recaptcha.test_mode! :return => false
      refute helper_test.recaptcha_valid?
    end
  end

  describe ".recaptcha_tag without request object" do

    it "should work without request object" do
      topic = helper_test_without_request.recaptcha_tag(:challenge)

      assert_match %r{script},            topic
      assert_match %r{challenge},         topic
      refute_match %r{recaptcha_ajax.js}, topic
      refute_match %r{RecaptchaOptions},  topic
      assert_match %r{#{'0'*40}},         topic
    end

  end

end
