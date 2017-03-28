module HorizonClient
  class Group < Collection
    def initialize(node)
      @node = node
      @rows = @node.locate('link').map do |row|
        Entity.new(row)
      end
    end

    def build
      row = Ox::Element.new('link')
      node << row
      entity = Entity.new(row)
      @rows.push(entity)
      entity
    end
  end
end
