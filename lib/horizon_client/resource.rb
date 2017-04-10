module HorizonClient
  class Resource
    attr_reader :document
    attr_reader :xml

    def initialize(xml)
      @document = Ox.parse(xml)
      @xml = xml
    end

    def entity
      node = @document.resource.entity
      Entity.new(node)
    end

    def result
      node = @document.result
      Entity.new(node)
    end

    def collection
      node = @document.resource.collection
      @collection ||= Collection.new(node)
    end

    def group
      node = @document.resource.group
      @group ||= Group.new(node)
    end

    def error
      if document.respond_to?('error')
        document.error.message.text
      end
    end
  end
end
