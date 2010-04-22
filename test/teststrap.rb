require 'rubygems'
require 'rack/test'
require 'rack/mock'
require 'rack/utils'
require 'rack/session/cookie'
require 'rack/builder'
require 'rr'
require 'riot'
require 'riot/rr'
require File.expand_path(File.join(File.dirname(__FILE__),'..','lib','rack-recaptcha'))

class Riot::Situation
  include Rack::Test::Methods

  def app
    main_app = lambda { |env|
      request = Rack::Request.new(env)
      return_code, body_text =
      case request.path
      when '/' then [200,'Hello world']
      when '/login'
        if request.post?
          request[:rack_recaptcha_value.to_s] == 'true' ? [200, 'post login'] : [200, 'post fail']
        else
          [200,'login']
        end
      else
        [404,'Nothing here']
      end
      [return_code,{'Content-type' => 'text/plain'}, body_text]
    }

    builder = Rack::Builder.new
    builder.use Rack::Recaptcha, :private_key => PRIVATE_KEY, :public_key => PUBLIC_KEY, :login_path => '/login'
    builder.run main_app
    builder.to_app
  end

end
