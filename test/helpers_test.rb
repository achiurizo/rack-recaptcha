require File.expand_path '../teststrap', __FILE__

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

context "Rack::Recaptcha::Helpers" do
  setup { Rack::Recaptcha.public_key = '0'*40 }

  helper(:helper_test) { HelperTest.new }


  context "recaptcha_tag" do

    context "ajax" do
      context "with display" do
        setup { helper_test.recaptcha_tag(:ajax,:display => {:theme => 'red'}) }

        asserts_topic('has js').matches %r{recaptcha_ajax.js}
        asserts_topic('has div').matches %r{<div id="ajax_recaptcha"></div>}
        asserts_topic('has display').matches %r{RecaptchaOptions}
        asserts_topic('has theme').matches %r{"theme":"red"}
      end
      context "without display" do
        setup { helper_test.recaptcha_tag(:ajax) }

        asserts_topic('has js').matches %r{recaptcha_ajax.js}
        asserts_topic('has div').matches %r{<div id="ajax_recaptcha"></div>}
        denies_topic('has display').matches %r{RecaptchaOptions}
        denies_topic('has theme').matches %r{"theme":"red"}
      end
    end

    context "noscript" do
      setup { helper_test.recaptcha_tag :noscript, :public_key => "hello_world_world" }

      asserts_topic("iframe").matches %r{iframe}
      asserts_topic("no script tag").matches %r{<noscript>}
      asserts_topic("public key").matches %r{hello_world_world}
      denies_topic("has js").matches %r{recaptcha_ajax.js}
    end

    context "challenge" do
      setup { helper_test.recaptcha_tag(:challenge) }

      asserts_topic("has script tag").matches %r{script}
      asserts_topic("has challenge js").matches %r{challenge}
      denies_topic("has js").matches %r{recaptcha_ajax.js}
      denies_topic("has display").matches %r{RecaptchaOptions}
      asserts_topic("has public_key").matches %r{#{'0'*40}}
    end

    context "server" do

      asserts("using ssl url") do
        helper_test.recaptcha_tag(:challenge, :ssl => true)
      end.matches %r{#{Rack::Recaptcha::API_SECURE_URL}}

      asserts("using non ssl url") do
        helper_test.recaptcha_tag(:ajax)
      end.matches %r{#{Rack::Recaptcha::API_URL}}
    end

  end

  context "recaptcha_valid?" do
    
    context "passing" do
      setup do
        mock(helper_test.request.env).[]('recaptcha.valid').returns(true)
      end

      asserts("retrieves request") { helper_test.recaptcha_valid? }
    end

    context "failing" do
      setup do
        mock(helper_test.request.env).[]('recaptcha.valid').returns(false)
      end

      denies("that it retrieves request") { helper_test.recaptcha_valid? }
    end

  end
end
