module ApiExplorer
  class Node
    attr_accessor :parent, :children, :path

    def initialize(parent = nil, children = nil, path = nil)
      self.parent   = parent || NullNode.new
      self.children = children || []
      self.path     = path.to_s

      self.children.each { |c| c.parent = self }
    end

    def full_path
      parent.full_path + path
    end


    private

      class NullNode
        def full_path
          ""
        end

        def method_missing
          nil
        end
      end
  end
end
