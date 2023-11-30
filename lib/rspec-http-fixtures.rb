# frozen_string_literal: true

require "rspec/core"
require "rspec-http-fixtures/helpers"

RSpec.configure do |config|
  config.add_setting(:http_fixtures_path, default: nil)

  config.include(RSpecHTTPFixtures::Helpers)
end

RSpec::Core::Configuration.class_eval do
  def http_fixtures_include(mod)
    RSpecHTTPFixtures::FixtureNamespace.class_eval do
      include(mod)
    end
  end
end
