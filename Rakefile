require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'metadata-json-lint/rake_task'
require 'puppet-syntax/tasks/puppet-syntax'

if RUBY_VERSION >= '1.9'
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
end

exclude_paths = [
  'pkg/**/*',
  'vendor/**/*',
  'spec/**/*',
]


PuppetLint::RakeTask.new :lint do |config|
  config.disable_checks = ['80chars', 'documentation']
  config.fail_on_warnings = true
  config.ignore_paths = exclude_paths
  config.log_format = '%{path}:%{line}:%{column}:%{check}:%{KIND}:%{message}'
  config.relative = true
end


desc 'Run metadata_lint, lint, validate, and spec tests.'
task :test => [
  :syntax,
  :lint,
  :spec,
]

