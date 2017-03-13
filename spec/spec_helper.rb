require "bundler/setup"
require "horizon_client"
require "horizon_client"
require 'webmock/rspec'

ENV['HORIZON_REST_URL'] = 'http://horizon.test'

module ClientHelperMethods
  def horizon_url(path, args = {})
    uri = HorizonClient.rest_uri(args)
    uri.path += "/#{path}"
    uri.to_s
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  include ClientHelperMethods
end
