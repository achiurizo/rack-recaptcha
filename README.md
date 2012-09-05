# rack-recaptcha [![](http://stillmaintained.com/achiu/rack-recaptcha.png)](http://stillmaintained.com/achiu/rack-recaptcha)

[![Build Status](https://secure.travis-ci.org/achiu/rack-recaptcha.png)](http://travis-ci.org/achiu/rack-recaptcha)

Drop this Rack middleware in your web application to enable CAPTCHA verification via Recaptcha API.

## How to Use

### Configuration

First, install the library with:
    [sudo] gem install rack-recaptcha

You have to require 'rack-recaptcha' in your gemfile.

````ruby
## Gemfile
gem 'rack-recaptcha', :require => 'rack/recaptcha'
````


    Available options for `Rack::Recaptcha` middleware are:

    * :public_key -- your ReCaptcha API public key *(required)*
    * :private_key -- your ReCaptcha API private key *(required)*
    * :proxy_host -- the HTTP Proxy hostname *(optional)*
    * :proxy_port -- the HTTP Proxy port *(optional)*
    * :proxy_user -- the HTTP Proxy user *(optional, omit unless the proxy requires it)*
    * :proxy_password -- the HTTP Proxy password *(optional, omit unless the proxy requires it)*

Now configure your app to use the middleware. This might be different across each web framework.

#### Sinatra

````ruby
## app.rb
use Rack::Recaptcha, :public_key => 'KEY', :private_key => 'SECRET'
helpers Rack::Recaptcha::Helpers
````

#### Padrino

````ruby
## app/app.rb
use Rack::Recaptcha, :public_key => 'KEY', :private_key => 'SECRET'
helpers Rack::Recaptcha::Helpers
````


#### Rails

````ruby
## application.rb:
module YourRailsAppName
  class Application < Rails::Application
    ...
    config.gem 'rack-recaptcha', :lib => 'rack/recaptcha'
    config.middleware.use Rack::Recaptcha, :public_key => 'KEY', :private_key => 'SECRET'
  end
end

## application_helper.rb or whatever helper you want it in.
module ApplicationHelper
  include Rack::Recaptcha::Helpers
end

## application_controller.rb or whatever controller you want it in.
class ApplicationController < ActionController::Base
  ...
  include Rack::Recaptcha::Helpers
  ...
end
````

### Helpers

The `Rack::Recaptcha::Helpers` module (for Sinatra, Rails, Padrino) adds these methods to your app:

Return a javascript recaptcha form
```ruby
  recaptcha_tag :challenge
```

Return a non-javascript recaptcha form
```ruby
  recaptcha_tag :noscript
```

Return a ajax recaptcha form
```ruby
  recaptcha_tag :ajax
```

For ajax recaptcha's, you can pass additional options like:
```ruby
  recaptcha_tag :ajax, :display => { :theme => 'red'}
```

For non-ajax recaptcha's, you can pass additional options like:
```ruby
  # Overrides the key set in Middleware
  recaptcha_tag :challenge, :public_key => KEY

  # Adjust Height and/or Width
  recaptcha_tag :noscript, :height => 300, :width => 500

  # Adjust the rows and/or columns
  recaptcha_tag :challenge, :row => 3, :cols => 5

  # Set the language
  recaptcha_tag :noscript, :language => :en
```

To test whether or not the verification passed, you can use:

```ruby
  recaptcha_valid?
```

The `recaptcha_valid?` helper can also be overloaded during tests. You
can set its response to either true or false by doing the following:

```ruby
 # Have recaptcha_valid? return true
 Rack::Recaptcha.test_mode!

 # Or have it return false
 Rack::Recaptcha.test_mode! :return => false
```


For additional options and resources checkout the [customization page](https://developers.google.com/recaptcha/docs/customization)

#### Example

In Padrino, here's how you would use the helpers.

````haml
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
````

In rails, you'll need to use also use the raw method:

````haml
## new.html.haml
- form_tag '/login' do
  = raw recaptcha_tag(:challenge)
  = submit_tag "Submit"
````

### Contributors

Daniel Mendler - [minad](https://github.com/minad)

  * support for multiple paths and helpers clean up

Eric Anderson - [eric1234](https://github.com/eric1234)

  * Make verify independently usable.

Chad Johnston - [iamthechad](https://github.com/iamthechad)

  * Adding Error Message handling in recaptcha widget

Eric Hu - [eric-hu](https://github.com/eric-hu)

  * Patching error message issue when no `request` is present

Tobias Begalke - [elcamino](https://github.com/elcamino)

  * Added HTTP Proxy support

Julik Tarkhanov - [julik](https://github.com/julik)

  * Adding rack-recaptcha to travis-ci

Rob Worley - [robworley](https://github.com/robworley)
  
  * Adding language setting for recaptcha form

#### Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

#### Copyright

Copyright (c) 2010, 2011, 2012 Arthur Chiu. See LICENSE for details.
