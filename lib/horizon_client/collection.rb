module HorizonClient
  class Collection
    include Enumerable

    attr_reader :node

    def initialize(node)
      @node = node
      @rows = @node.locate(row_element_name).map do |row|
        Entity.new(row)
      end
    end

    def build
      row = Ox::Element.new(row_element_name)
      node << row
      entity = Entity.new(row)
      @rows.push(entity)
      entity
    end

    def rows
      @rows
    end

    def each(&block)
      @rows.each(&block)
    end

    private

    def row_element_name
      'row'
    end
  end
end
