module HorizonClient
  class Entity
    attr_reader :node

    def initialize(node)
      @node = node
    end

    def [](name)
      attr_node = node.locate(name).first
      get_value attr_node
    end

    def []=(name, value)
      elem = find_or_build_attribute(name.split('/'), node)
      elem.replace_text(value)
    end

    def get_collection(name)
      collection_node = find_or_build_attribute(name.split('/'), node)
      Collection.new(collection_node)
    end

    private

    def find_or_build_attribute(path, parent)
      name = path.shift
      unless child = parent.locate(name).first
        child = Ox::Element.new(name)
        parent << child
      end
      find_or_build_attribute(path, child) unless path.empty?

      child
    end

    def get_value(node)
      if node.respond_to?('href')
        node.href.text
      else
        node.text
      end
    end
  end
end
