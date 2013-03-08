require 'rubygems'
gem 'minitest'
require 'minitest/autorun'
require 'rack/test'
require 'rack/mock'
require 'rack/utils'
require 'rack/session/cookie'
require 'rack/builder'
require 'fakeweb'
require 'rr'
require File.expand_path '../../lib/rack/recaptcha', __FILE__

PUBLIC_KEY  = '0'*40
PRIVATE_KEY = 'X'*40

class MiniTest::Spec
  include Rack::Test::Methods
  include RR::Adapters::MiniTest

  def app
    main_app = lambda { |env|
      request = Rack::Request.new(env)
      return_code, body_text =
      case request.path
      when '/' then [200,'Hello world']
      when '/login'
        if request.post?
          env['recaptcha.valid'] ? [200, 'post login'] : [200, 'post fail']
        else
          [200,'login']
        end
      else
        [404,'Nothing here']
      end
      [return_code,{'Content-type' => 'text/plain'}, [body_text]]
    }

    builder = Rack::Builder.new
    builder.use Rack::Recaptcha, :private_key => PRIVATE_KEY, :public_key => PUBLIC_KEY
    builder.run main_app
    builder.to_app
  end
end
