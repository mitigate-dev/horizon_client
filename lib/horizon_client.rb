require "horizon_client/version"
require "faraday"
require "multi_xml"
require "faraday_middleware"

module HorizonClient
  def self.new(args = {})
    Connection.new(rest_uri(args))
  end

  def self.rest_uri(args = {})
    base = args.fetch(:url, nil) || ENV['HORIZON_REST_URL']
    uri = URI(base)
    uri.path = '/rest'
    uri
  end

  class ClientError < Faraday::ClientError
    def initialize(e)
      info = e.response ? e.response[:body].fetch('error', {}).fetch('message', '') : ''
      super [e.message, info].join(': ')
    end
  end

  class Connection
    def initialize(rest_uri)
      @connection = Faraday.new rest_uri.to_s do |conn|
        conn.response :raise_error
        conn.response :xml,  :content_type => /\bxml$/

        conn.adapter Faraday.default_adapter
      end
    end

    def get(path = '', params = {})
      response = @connection.get path, params
      response.body

    rescue Faraday::ClientError => e
      raise ClientError.new(e)
    end

    def post(path = '', body)
      response = @connection.post do |req|
        req.url path
        req.headers['Content-Type'] = 'application/xml;charset=UTF-8'
        req.body = body
      end

      response.body
    rescue Faraday::ClientError => e
      raise ClientError.new(e)
    end
  end
end
