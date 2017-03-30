require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'metadata-json-lint/rake_task'
require 'puppet-syntax/tasks/puppet-syntax'
require 'puppet-strings/tasks'

if RUBY_VERSION >= '1.9'
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new(:style) do |rubocop|
    rubocop.options = ['-l', '--no-color']
  end
end

exclude_paths = [
  'pkg/**/*',
  'vendor/**/*',
  'spec/**/*'
]

PuppetLint::RakeTask.new :lint do |config|
  config.disable_checks = %w(80chars documentation)
  config.fail_on_warnings = true
  config.ignore_paths = exclude_paths
  config.log_format = '%{path}:%{line}:%{column}:%{check}:%{KIND}:%{message}'
  config.relative = true
end

desc 'Run metadata_lint, lint, validate, and spec tests.'
task test: %i(
  syntax
  lint
  style
  spec
)
