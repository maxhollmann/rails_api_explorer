module ApiExplorer
  class Group < Node
    attr_accessor :headers, :params

    def initialize(path, children, shared_headers, shared_params)
      super nil, children, path

      self.headers = shared_headers
      self.params  = shared_params
    end

    def add_child(child)
      children << child
      child.parent = self
    end
  end
end
