require "horizon_client/version"
require "faraday"
require "multi_xml"
require "faraday_middleware"

module HorizonClient
  def self.new(*args)
    Connection.new(*args)
  end

  class ClientError < Faraday::ClientError
    def initialize(e)
      info = e.response ? e.response[:body].fetch('error', {}).fetch('message', '') : ''
      super [e.message, info].join(': ')
    end
  end

  class Connection
    def initialize(url = nil)
      url ||=  ENV['HORIZON_REST_URL']

      @connection = Faraday.new url do |conn|
        conn.response :raise_error
        conn.response :xml,  :content_type => /\bxml$/

        conn.adapter Faraday.default_adapter
      end
    end

    def url_prefix
      @connection.url_prefix
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
