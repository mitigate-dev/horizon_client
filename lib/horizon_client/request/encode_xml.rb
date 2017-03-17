module HorizonClient
  module Request
    class EncodeXml < Faraday::Middleware
      def call(env)
        env[:body] = encode env[:body]
        @app.call env
      end

      def encode(payload)
        payload.is_a?(Resource) ? Ox.dump(payload.document, with_xml: true) : payload
      end
    end
  end
end
