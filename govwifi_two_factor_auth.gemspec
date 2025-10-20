# frozen_string_literal: true

require_relative "lib/govwifi_two_factor_auth/version"

Gem::Specification.new do |spec|
  spec.name        = "govwifi_two_factor_auth"
  spec.version     = GovwifiTwoFactorAuth::VERSION
  spec.authors     = %w[koetsier]
  spec.email       = ["jos.koetsier@digital.cabinet-office.gov.uk"]
  spec.homepage    = "https://github.com/govwifi/govwifi_two_factor_auth"
  spec.summary     = "Devise plugin for 2FA"
  spec.description = "Devise plugin for 2FA. Fork from https://github.com/Houdini/two_factor_authentication"
  spec.license     = "MIT"
  spec.required_ruby_version = ">= 3.1"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_runtime_dependency "devise"
  spec.add_runtime_dependency "encryptor"
  spec.add_runtime_dependency "randexp"
  spec.add_runtime_dependency "rotp", ">= 4.0.0"

  spec.test_files = Dir["spec/**/*"]
  spec.add_development_dependency "capybara"
  spec.add_development_dependency "factory_bot", "~> 6.5"
  spec.add_development_dependency "generator_spec"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "rubocop-govuk"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "timecop"
  spec.add_dependency "rack", ">= 3.2.3"
  spec.add_dependency "rails", ">= 7.0.2"
end
