require 'active_support/core_ext/hash/reverse_merge'
require 'active_support/json'

RECAPTCHA_API_URL        = 'http://api.recaptcha.net'
RECAPTCHA_API_SECURE_URL = 'https://api-secure.recaptcha.net'
RECAPTCHA_VERIFY_URL     = 'http://api-verify.recaptcha.net/verify'


require File.expand_path(File.join(File.dirname(__FILE__),'rack-recaptcha','recaptcha'))
require File.expand_path(File.join(File.dirname(__FILE__),'rack-recaptcha','helpers'))