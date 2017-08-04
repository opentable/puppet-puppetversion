source ENV['GEM_SOURCE'] || 'https://rubygems.org'

facterversion = ENV['FACTER_GEM_VERSION']
puppetversion = ENV['PUPPET_GEM_VERSION']

def location_for(place, fake_version = nil)
  if place =~ %r{/^(git[:@][^#]*)#(.*)/}
    [fake_version,
     { git: Regexp.last_match[1], branch: Regexp.last_match[2], require: false }
    ].compact
  elsif place =~ %r{/^file://(.*)/}
    ['>= 0', { path: File.expand_path(Regexp.last_match[1]), require: false }]
  else
    [place, { require: false }]
  end
end

group :test do
  gem 'rake', '~> 11.3',                                            :require => false
  gem 'rspec', '~> 3.5',                                            :require => false

  if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.0.0')
    gem 'json_pure', '<= 2.0.1',                                    :require => false
    gem 'metadata-json-lint', '<= 1.1.0',                           :require => false
  else
    # metadata-json-lint 2.x requires semantic_puppet for Puppet < 4.9
    if Gem::Version.new(puppetversion) < Gem::Version.new('4.9')
      gem 'semantic_puppet', :require => false
    end
    gem 'metadata-json-lint', '2.0.0',                              :require => false
  end

  gem 'faraday', '~> 0.9',                                          :require => false
  gem 'faraday_middleware', '~> 0.9',                               :require => false

  gem 'puppetlabs_spec_helper', '~> 1.2',                           :require => false
  gem 'puppet-lint', '~> 2.0',                                      :require => false
  gem 'rspec-puppet', '~> 2.0',                                     :require => false
  gem 'puppet-blacksmith', '~> 3.4',                                :require => false

  gem 'voxpupuli-release',                                          :require => false, :git => 'https://github.com/voxpupuli/voxpupuli-release-gem.git'

  gem 'rspec-puppet-utils',                                         :require => false
  gem 'puppet-lint-absolute_classname-check',                       :require => false
  gem 'puppet-lint-leading_zero-check',                             :require => false
  gem 'puppet-lint-trailing_comma-check',                           :require => false
  gem 'puppet-lint-version_comparison-check',                       :require => false
  gem 'puppet-lint-classes_and_types_beginning_with_digits-check',  :require => false
  gem 'puppet-lint-unquoted_string-check',                          :require => false
  gem 'puppet-lint-variable_contains_upcase',                       :require => false
  gem 'safe_yaml', '~>1.0.4'
end

group :development do
  gem 'travis',            :require => false
  gem 'travis-lint',       :require => false
  gem 'guard-rake',        :require => false
  gem 'rubocop', '0.37.0', :require => false
end

group :system_tests do
  gem 'beaker',                        :require => false
  if beaker_version = ENV['BEAKER_VERSION']
    gem 'beaker', *location_for(beaker_version)
  end
  if beaker_rspec_version = ENV['BEAKER_RSPEC_VERSION']
    gem 'beaker-rspec', *location_for(beaker_rspec_version)
  else
    gem 'beaker-rspec',  :require => false
  end
  gem 'beaker-puppet_install_helper',  :require => false
end

if facterversion
  gem 'facter', facterversion, :require => false
else
  gem 'facter', :require => false
end

if puppetversion
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', '> 3.0.0', '< 4.0.0', :require => false
end


# vim:ft=ruby
