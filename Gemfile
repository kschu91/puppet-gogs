source ENV['GEM_SOURCE'] || 'https://rubygems.org'

gem 'metadata-json-lint'
gem 'puppet', ENV.key?('PUPPET_GEM_VERSION') ? ENV['PUPPET_GEM_VERSION'] : ['>= 3.3']
gem 'puppetlabs_spec_helper', '>= 1.0.0'
gem 'puppet-lint', '>= 1.0.0'
gem 'facter', '>= 1.7.0'
gem 'rspec-puppet'

if RUBY_VERSION >= '2.0'
  gem 'rubocop'
end