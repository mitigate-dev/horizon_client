require "horizon_client/version"
require "faraday"
require "ox"

require 'horizon_client/response/parse_xml'
require 'horizon_client/request/encode_xml'

require "horizon_client/resource"
require "horizon_client/collection"
require "horizon_client/entity"

module HorizonClient
  def self.new(*args)
    Connection.new(*args)
  end

  class Connection
    def initialize(url = nil)
      url ||=  ENV['HORIZON_REST_URL']

      @connection = Faraday.new url do |conn|
        conn.response :raise_error
        conn.use HorizonClient::Response::ParseXml
        conn.use HorizonClient::Request::EncodeXml

        conn.adapter Faraday.default_adapter
      end
    end

    def url_prefix
      @connection.url_prefix
    end

    def get(path = '', params = {})
      response = @connection.get path, params
      response.body
    end

    def post(path = '', body)
      response = @connection.post do |req|
        req.url path
        req.headers['Content-Type'] = 'application/xml;charset=UTF-8'
        req.body = body
      end

      response.body
    end
  end
end
