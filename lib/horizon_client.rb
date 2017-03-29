require "horizon_client/version"
require "faraday"
require "ox"

require 'horizon_client/connection'

require 'horizon_client/response/parse_xml'
require 'horizon_client/request/encode_xml'

require "horizon_client/resource"
require "horizon_client/collection"
require "horizon_client/group"
require "horizon_client/entity"

module HorizonClient
  def self.new(*args)
    Connection.new(*args)
  end
end
