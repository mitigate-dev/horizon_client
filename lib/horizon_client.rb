require "horizon_client/version"
require "faraday"
require "multi_xml"
require "faraday_middleware"

module HorizonClient
  def self.new
    Connection.new(rest_base)
  end

  def self.rest_base
    uri = URI(ENV['HORIZON_REST_URL'])
    uri.path = '/rest'
    uri.to_s
  end

  class Error < StandardError
    def initialize(e)
      info = e.response ? e.response[:body].fetch('error', {}).fetch('message', '') : ''
      super [e.message, info].join(': ')
    end
  end

  class Connection
    def initialize(rest_base)
      @connection = Faraday.new rest_base do |conn|
        conn.response :raise_error
        conn.response :xml,  :content_type => /\bxml$/

        conn.basic_auth ENV['HORIZON_USERNAME'], ENV['HORIZON_PASSWORD']

        conn.adapter Faraday.default_adapter
      end
    end

    def get(path = '', params = {})
      response = @connection.get path, params
      response.body

    rescue Faraday::ClientError => e
      raise Error.new(e)
    end

    def post(path = '', body)
      response = @connection.post do |req|
        req.url path
        req.headers['Content-Type'] = 'application/xml;charset=UTF-8'
        req.body = body
      end

      response.body
    rescue Faraday::ClientError => e
      raise Error.new(e)
    end
  end
end
