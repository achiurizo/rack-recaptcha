# rack-recaptcha [![](http://stillmaintained.com/achiu/rack-recaptcha.png)](http://stillmaintained.com/achiu/rack-recaptcha)

Drop this Rack middleware in your web application to enable CAPTCHA verification via Recaptcha API.

## How to Use

### Configuration

First, install the library with:
    [sudo] gem install rack-recaptcha

You have to require 'rack-recaptcha' in your gemfile.

    ## Gemfile
    gem 'rack-recaptcha', :require => 'rack/recaptcha'
    
    
    Available options for `Rack::Recaptcha` middleware are:

    * :public_key -- your ReCaptcha API public key *(required)*
    * :private_key -- your ReCaptcha API private key *(required)*
    * :paths -- where user goes to login or access the recaptcha (array of paths or single path)


Now configure your app to use the middleware. This might be different across each web framework.

#### Sinatra
    ## app.rb
    use Rack::Recaptcha, :public_key => 'KEY', :private_key => 'SECRET', :paths => 'PATH'
    helpers Rack::Recaptcha::Helpers

#### Padrino

    ## app/app.rb
    use Rack::Recaptcha, :public_key => 'KEY', :private_key => 'SECRET', :paths => 'PATH'
    helpers Rack::Recaptcha::Helpers


#### Rails

    ## application.rb:
    class Application < Rails::Application
    # ...
      config.gem 'rack-recaptcha', :lib => 'rack/recaptcha'
      config.middleware.use Rack::Recaptcha, :public_key => 'KEY', :private_key => 'SECRET', :paths => 'PATH'
    end

    ## application_helper.rb
    module ApplicationHelper
      include Rack::Recaptcha::Helpers
    end

### Helpers

The `Rack::Recaptcha::Helpers` module (for Sinatra, Rails, Padrino) adds these methods to your app:

* `recaptcha_tag(type,options={})` -- generates the appropriate recaptcha scripts. must be included in a form_tag
  - recaptcha\_tag(:challenge) => generates a recaptcha script
  - recaptcha\_tag(:ajax) => generates an ajax recaptcha script
    - if passed in a :display option, you can further alter the recaptcha\_tag
      - recaptcha\_tag(:ajax, :display => {:theme => 'white'}) - recaptcha tag in white theme.
  - recaptcha\_tag(:noscript) => generates a recaptcha noscript
  - you can also pass in :public\_key manually as well.
    - recaptcha\_tag(:challenge,:public\_key => 'PUBLIC')

* `recaptcha_valid?` -- returns whether or not the verification passed.

#### Example

In Padrino, here's how you would use the helpers.

    ## new.haml
    - form_tag '/login', :class => 'some_form', :method => 'post' do
      = text_field_tag :email
      = password_field_tag :password
      = recaptcha_tag(:challenge)
      = submit_tag "Submit"
      
    ## sessions.rb
    post :create, :map => '/login' do
      if recaptcha_valid?
        "passed!"
        else
        "failed!"
      end
    end

In rails, you'll need to use also use the raw method:

    ## new.html.haml
    - form_tag '/login' do
      = raw recaptcha_tag(:challenge)
      = submit_tag "Submit"

### Contributors

- Daniel Mendler(minad) - support for multiple paths and helpers clean up
- Eric Anderson(eric1234) - Make verify independently usable.


#### Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

#### Copyright

Copyright (c) 2011 Arthur Chiu. See LICENSE for details.
