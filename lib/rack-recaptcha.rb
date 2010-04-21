require 'httparty'
require 'active_support/core_ext/hash/reverse_merge'
require 'active_support/json'

RECAPTCHA_API_SERVER        = 'http://api.recaptcha.net'
RECAPTCHA_API_SECURE_SERVER = 'https://api-secure.recaptcha.net'
RECAPTCHA_VERIFY_SERVER     = 'api-verify.recaptcha.net'


require File.expand_path(File.join(File.dirname(__FILE__),'rack-recaptcha','recaptcha'))
require File.expand_path(File.join(File.dirname(__FILE__),'rack-recaptcha','helpers'))