Gem::Specification.new do |s|
  s.name = %q{rack-recaptcha}
  s.version = "0.6.5"
  s.required_rubygems_version = ">=1.3.6"
  s.authors = ["Arthur Chiu"]
  s.date = %q{2010-07-18}
  s.description = %q{Rack middleware Captcha verification using Recaptcha API.}
  s.email = %q{mr.arthur.chiu@gmail.com}
  s.extra_rdoc_files = ["LICENSE", "README.md"]
  s.files = %w{.document .gitignore LICENSE README.md Rakefile rack-recaptcha.gemspec} + Dir.glob("{lib,test}/**/*")
  s.homepage = %q{http://github.com/achiu/rack-recaptcha}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Rack middleware for Recaptcha}
  s.test_files = Dir.glob("test/**/*")
  s.add_runtime_dependency "json", ">= 0"
  s.add_development_dependency "rake",      "~> 0.9.2"
  s.add_development_dependency "riot",      "~> 0.12.3"
  s.add_development_dependency "rack-test", "~> 0.5.7"
  s.add_development_dependency "fakeweb",   "~> 1.3.0"
  s.add_development_dependency "rr",        "~> 1.0.2"
end
