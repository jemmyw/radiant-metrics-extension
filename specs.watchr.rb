# Run me with:
#
#   $ watchr specs.watchr.rb

# --------------------------------------------------
# Convenience Methods
# --------------------------------------------------
def all_test_files
  Dir['spec/**/*.rb']
end

def run(cmd)
  puts(cmd)
  system(cmd)
end

def run_spec(spec)
  run("spec -O spec/spec.opts spec/%s" % spec)
end

def run_glob_spec(spec)
  run('spec -O spec/spec.opts %s' % Dir.glob('spec/%s' % spec).join(' '))
end

def run_all_tests
  cmd = "rake spec"
  run(cmd)
end

# --------------------------------------------------
# Watchr Rules
# --------------------------------------------------
watch('^spec/.*_spec\.rb')                {|m| run("spec -O spec/spec.opts %s" % m[0]) }
watch('^app/(.*?)/(.*)\.rb$')             {|m| run_spec('%s/%s_spec.rb' % [m[1], m[2]]) }
watch('^app/views/(.*?)/(.*)')            {|m| run_spec('views/%s/%s_spec.rb' % [m[1], m[2]]) }
watch('^lib/(.*)\.rb')                    {|m| run_spec('lib/%s_spec.rb' % m[1]) }
watch('^spec/spec_helper.rb')             { run_all_tests }

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
