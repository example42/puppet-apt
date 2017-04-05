source 'https://rubygems.org'

if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion, :require => false
else
  gem 'facter', :require => false
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
  gem 'rake', '~> 10.5', :platforms => :ruby_18
  # Puppet 2.7 and Ruby 1.8 fails with newer rspec
  gem 'rspec', '~>3.1.0', :require => false, :platform => [:ruby_18]
else
  gem 'puppet', :require => false
end

group :development, :unit_tests do
  gem 'json', '~> 1.0',  :require => false if Gem::Version.new(RUBY_VERSION.dup) < Gem::Version.new('2.0.0')
  gem 'json_pure', '~> 1.0',  :require => false if Gem::Version.new(RUBY_VERSION.dup) < Gem::Version.new('2.0.0')
  gem 'puppet-lint'
  gem 'puppetlabs_spec_helper', '>= 0.1.0'
end

# vim:ft=ruby
