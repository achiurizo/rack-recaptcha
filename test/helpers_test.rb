require File.expand_path '../teststrap', __FILE__

class HelperTest
  attr_accessor :request
  include Rack::Recaptcha::Helpers
  
  def initialize
    @request = HelperTest::Request.new
  end
  
  class Request
    #def initialize
    #  @env = Hash.new
    #end
    attr_accessor :env
  end
end

context "Rack::Recaptcha::Helpers" do
  helper(:helper_test) { HelperTest.new }

  setup do
    #mock(helper_test.request.env).[]('recaptcha.message')
    Rack::Recaptcha.public_key = '0'*40
  end

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

=begin
    context "challenge with error" do
      mock(helper_test.request.env).[]('recaptcha.message').returns("Sample Error")
      setup do

        helper_test.recaptcha_tag(:challenge)
      end

      asserts_topic("has script tag").matches %r{script}
      asserts_topic("has challenge js").matches %r{challenge}
      denies_topic("has js").matches %r{recaptcha_ajax.js}
      denies_topic("has display").matches %r{RecaptchaOptions}
      asserts_topic("has public_key").matches %r{#{'0'*40}}
      asserts_topic("has previous error").matches %r{Sample Error}
    end
=end

    context "server" do

      asserts("using ssl url") do
        helper_test.recaptcha_tag(:challenge, :ssl => true)
      end.matches %r{#{Rack::Recaptcha::API_SECURE_URL}}

      asserts("using non ssl url") do
        helper_test.recaptcha_tag(:ajax)
      end.matches %r{#{Rack::Recaptcha::API_URL}}
    end

  end

  context "recaptcha_tag_errors" do
    #setup { mock(helper_test.request.env).[]('recaptcha.message').returns("Sample Error") }
=begin
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
=end

    context "challenge with error" do
      asserts "HTML contains error message" do
      #setup do
        mock(helper_test.request.env).[]('recaptcha.message').returns("Sample Error")
        puts helper_test.request.env
        #request.env = mock!.[]('recaptcha.message') {"Yo"}
        helper_test.recaptcha_tag(:challenge)
      #end

      #asserts_topic("has script tag").matches %r{script}
      #asserts_topic("has challenge js").matches %r{challenge}
      #denies_topic("has js").matches %r{recaptcha_ajax.js}
      #denies_topic("has display").matches %r{RecaptchaOptions}
      #asserts_topic("has public_key").matches %r{#{'0'*40}}
      #asserts_topic("has previous error").matches %r{Sample Error}
        end
    end
  end

  context "recaptcha_valid?" do

    asserts "that it passes when recaptcha.valid is true" do
      mock(helper_test.request.env).[]('recaptcha.valid').returns(true)
      puts helper_test.request.inspect
      helper_test.recaptcha_valid?
    end

    denies "that it passes when recaptcha.valid is false" do
      mock(helper_test.request.env).[]('recaptcha.valid').returns(false)
      helper_test.recaptcha_valid?
    end

    asserts "that it passes when test mode set to pass" do
      Rack::Recaptcha.test_mode!
      helper_test.recaptcha_valid?
    end

    denies "that it passes when test mode set to fil" do
      Rack::Recaptcha.test_mode! :return => false
      helper_test.recaptcha_valid?
    end

  end
end
