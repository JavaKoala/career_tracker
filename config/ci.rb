CI.run do
  step 'Setup', 'bin/setup --skip-server'
  step 'Style: Ruby', 'bin/rubocop'

  step 'Security: Gem audit', 'bin/bundler-audit'
  step 'Security: Importmap vulnerability audit', 'bin/importmap audit'
  step 'Security: Brakeman code analysis', 'bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error'

  if ENV['SKIP_FLAKY'] == 'true'
    step 'Tests: Rspec', 'bundle exec rspec --tag "~ci_flaky"'
  else
    step 'Tests: Rspec', 'bundle exec rspec'
  end
end
