module HorizonClient
  module Response

    class ResourceError < StandardError
    end

    class ParseXml < Faraday::Response::Middleware
      def parse(body)
        resource = Resource.new(body)

        raise ResourceError.new(resource.error) if resource.error

        resource
      end
    end
  end
end
