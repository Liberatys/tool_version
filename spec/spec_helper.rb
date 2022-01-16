# frozen_string_literal: true

require "simplecov"
SimpleCov.start

require "tool_version"
require "vcr"
require "webmock/rspec"
require "octokit"

$LOAD_PATH.unshift File.expand_path("support", __dir__)
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

VCR.configure do |config|
  config.ignore_hosts "127.0.0.1", "localhost", "chromedriver.storage.googleapis.com"
  config.before_record do |i|
    i.request.headers.delete("Authorization")
  end
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
