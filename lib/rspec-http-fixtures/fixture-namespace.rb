module RSpecHTTPFixtures
  class FixtureNamespace
    def initialize(context:, path:, params: {})
      @context = context
      @path = path

      params.each do |key, value|
        set(key, value)
      end
    end

    def set(key, value)
      instance_variable_set("@#{key}", value)
    end

    def build_fixture_path(path)
      # Can convert relative path to absolute path
      "#{File.expand_path(path, File.dirname(@path))}.erb"
    end

    # To be used with arrays and objects for json fixtures and returns the actual data or null if nil
    def build_json_data(value, default = nil)
      value ||= default

      build_json_null(value) || (value.is_a?(String) ? value : value.to_json)
    end

    # Used to build JSON pairs to add to an existing object
    # @example
    #   In the JSON fixture file:
    #
    #   {
    #     <%= build_json_pairs("foo" => "1", "bar" => "2") %>
    #   }
    #
    #   results in final output:
    #
    #   {
    #     "foo": "1",
    #     "bar": "2"
    #   }
    def build_json_data_pairs(pairs)
      build_json_data(pairs)[1..-2]
    end

    # Returns string value enclosed in quotes or null if nil for json fixtures. Can also be forced to be null by
    # passing in the string: "null"
    def build_json_string(value, default = nil)
      value ||= default

      # Ensure any double quotes are escaped since they are part of string and won't mess up the entire JSON
      build_json_null(value) || "\"#{value.to_s.gsub('"', '\"')}\""
    end

    # Returns integer value or null if nil for json fixtures. Can also be forced to be null by passing in the
    # string: "null"
    def build_json_number(value, default = nil)
      value ||= default

      build_json_null(value) || value
    end

    # Returns boolean value or null if nil for json fixtures. Can also be forced to be null by passing in the
    # string: "null". Can provide default if value is nil
    def build_json_boolean(value, default = nil)
      return "null" if value == "null"
      return value unless value.nil?

      default.is_a?(TrueClass) || default.is_a?(FalseClass) ? default : "null"
    end

    def build_json_iso8601(value, default = nil, precision: 0)
      value ||= default

      build_json_null(value) || build_json_string(value.is_a?(String) ? value : value.iso8601(precision))
    end

    def build_json_epoch(value)
      build_json_number(value&.to_i)
    end

    def build_json_null(value)
      value.nil? || value == "null" ? "null" : nil
    end

    def build_json_collection_fixture(fixture, params_collection = [])
      @context.build_json_collection_http_fixture(build_fixture_path(fixture), params_collection)
    end

    def build_xml_collection_fixture(fixture, params_collection = [])
      params_collection.map { |p| @context.read_http_fixture(build_fixture_path(fixture), p) }.join("")
    end

    # rubocop:disable Style/MethodMissingSuper
    # rubocop:disable Style/MissingRespondToMissing
    def method_missing(name, *args)
      instance_variable = "@#{name}"

      # First try to see if it's a param we're trying to access which is stored in an instance variable otherwise
      # try to see if there's a method currently on class (from includes)
      if instance_variable_defined?(instance_variable)
        instance_variable_get(instance_variable)
      elsif respond_to?(name)
        send(name, *args)
      end
    end
    # rubocop:enable Style/MethodMissingSuper
    # rubocop:enable Style/MissingRespondToMissing
  end
end
