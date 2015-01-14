module ApiExplorer
  class Header
    def initialize(name, options = {})
      self.name = name.to_s
      self.source = options[:source] || {}
    end

    attr_accessor :name, :source
  end
end
