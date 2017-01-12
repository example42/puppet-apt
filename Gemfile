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

if RUBY_VERSION.to_i < 2
  gem 'json_pure', '<2'
  gem 'json', '<2'
end

gem 'puppet-lint'
gem 'puppetlabs_spec_helper', '>= 0.1.0'
gem 'rspec-puppet'
gem 'metadata-json-lint'

group :development do
  gem 'puppet-blacksmith'
end

# puppet lint plugins
# https://puppet.community/plugins/#puppet-lint
gem 'puppet-lint-appends-check',
    :git => 'https://github.com/voxpupuli/puppet-lint-appends-check.git',
    :require => false
gem 'puppet-lint-classes_and_types_beginning_with_digits-check',
    :git => 'https://github.com/voxpupuli/puppet-lint-classes_and_types_beginning_with_digits-check.git',
    :require => false
#gem 'puppet-lint-empty_string-check',
#    :git => 'https://github.com/voxpupuli/puppet-lint-empty_string-check.git',
#    :require => false
gem 'puppet-lint-file_ensure-check',
    :git => 'https://github.com/voxpupuli/puppet-lint-file_ensure-check.git',
    :require => false
gem 'puppet-lint-leading_zero-check',
    :git => 'https://github.com/voxpupuli/puppet-lint-leading_zero-check.git',
    :require => false
gem 'puppet-lint-numericvariable',
    :git => 'https://github.com/fiddyspence/puppetlint-numericvariable.git',
    :require => false
gem 'puppet-lint-resource_reference_syntax',
    :git => 'https://github.com/voxpupuli/puppet-lint-resource_reference_syntax.git',
    :require => false
gem 'puppet-lint-spaceship_operator_without_tag-check',
    :git => 'https://github.com/voxpupuli/puppet-lint-spaceship_operator_without_tag-check.git',
    :require => false
gem 'puppet-lint-trailing_comma-check',
    :git => 'https://github.com/voxpupuli/puppet-lint-trailing_comma-check.git',
    :require => false
gem 'puppet-lint-undef_in_function-check',
    :git => 'https://github.com/voxpupuli/puppet-lint-undef_in_function-check.git',
    :require => false
gem 'puppet-lint-unquoted_string-check',
    :git => 'https://github.com/voxpupuli/puppet-lint-unquoted_string-check.git',
    :require => false
gem 'puppet-lint-variable_contains_upcase',
    :git => 'https://github.com/fiddyspence/puppetlint-variablecase.git',
    :require => false
gem 'puppet-lint-version_comparison-check',
    :git => 'https://github.com/voxpupuli/puppet-lint-version_comparison-check.git',
    :require => false
