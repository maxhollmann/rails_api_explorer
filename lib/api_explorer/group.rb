module ApiExplorer
  class Group < Node
    attr_accessor :shared_headers, :shared_params

    def initialize(path, children, shared_headers, shared_params)
      super nil, children, path

      self.shared_headers = shared_headers
      self.shared_params  = shared_params
    end
  end
end
