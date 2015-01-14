module ApiExplorer
  class Parameter
    def initialize(name, type_or_children, description)
      self.name = name.to_s
      self.description = description
      if type_or_children.is_a?(Array)
        self.type = :hash
        self.children = type_or_children
      else
        self.type = type_or_children.to_sym
      end
    end

    attr_accessor :name, :type, :children, :description
  end
end
