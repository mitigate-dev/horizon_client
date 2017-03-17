module HorizonClient
  class Resource
    attr_reader :document

    def initialize(xml)
      @document = Ox.parse(xml)
    end

    def entity
      node = @document.resource.entity
      Entity.new(node)
    end

    def collection
      node = @document.resource.collection
      @collection ||= Collection.new(node)
    end

    def error
      if document.respond_to?('error')
        document.error.message.text
      end
    end
  end
end
