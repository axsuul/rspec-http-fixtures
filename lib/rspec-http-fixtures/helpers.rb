require_relative "fixture-namespace"

module RSpecHTTPFixtures
  module Helpers
    def build_http_fixture_path(path)
      RSpec.configuration.http_fixtures_path.join(path)
    end

    def open_http_fixture(path)
      File.open(build_http_fixture_path(path))
    end

    def read_http_fixture(read_http_fixture_path, read_fixture_params = {}, *read_fixture_args)
      # Copy the params so the original doesn't get mutated
      read_fixture_params = read_fixture_params.deep_dup

      # If path is a symbol then we can assume it's a method so let's call it Otherwise, we assume it's a relative
      # path to our fixture. We use long variables since these variables are also of the same scope that is being
      # passed into the ERB template so we don't want to collide with anything in the namespace
      read_fixture_body =
        if read_http_fixture_path.is_a?(Symbol)
          send(read_http_fixture_path, read_fixture_params, *read_fixture_args)
        else
          # Chomp to get rid of newline at end
          open_http_fixture(read_http_fixture_path).read.chomp
        end

      # Return raw body unless it is an ERB. If it's ERB, then render it with params
      return read_fixture_body unless File.extname(read_http_fixture_path.to_s) == ".erb"

      unless read_fixture_params.is_a?(Hash)
        raise ArgumentError, "params must be a Hash, instead it's #{read_fixture_params.inspect}"
      end

      # Use ERB to inject variables into body
      erb = ERB.new(read_fixture_body)

      # We use a custom namespace class so that we can include helper methods
      # into the namespace to make them available for template to access
      namespace = FixtureNamespace.new(
        context: self,
        path: build_http_fixture_path(read_http_fixture_path),
        params: read_fixture_params,
      )

      erb.result(namespace.instance_eval { binding })
    end

    def build_json_collection_http_fixture(path, collection_params)
      return unless collection_params

      collection_params.map { |p| JSON.parse(read_http_fixture(path, p)) }.to_json
    end
  end
end
