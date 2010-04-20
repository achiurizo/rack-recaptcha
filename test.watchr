#
# 'autotest' for riot
# install watchr
# $ sudo gem install watchr
# 
# Run With:
# $ watchr test.watchr
#

# --------------------------------------------------
# Helpers
# --------------------------------------------------

def run(cmd)
  puts(cmd)
  system(cmd)
end

def run_all_tests
  system( "rake test" )
end

def sudo(cmd)
  run("sudo #{cmd}")
end

# --------------------------------------------------
# Watchr Rules
# --------------------------------------------------
watch("^lib.*/(.*)\.rb") { |m| run("ruby test/#{m[1]}_test.rb") }
watch("test.*/teststrap\.rb") { run_all_tests }
watch("^test/(.*)_test\.rb")  { |m| run("ruby test/#{m[1]}_test.rb")}


# --------------------------------------------------
# Signal Handling
# --------------------------------------------------
# Ctrl-\
Signal.trap('QUIT') do
  puts " --- Running all tests ---\n\n"
  run_all_tests
end
 
# Ctrl-C
Signal.trap('INT') { abort("\n") }