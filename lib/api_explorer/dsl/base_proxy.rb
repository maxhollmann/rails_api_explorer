module ApiExplorer
  class BaseProxy
    attr_accessor :obj

    def initialize(obj = nil)
      self.obj = obj
    end

    def collect(&block)
      instance_eval(&block)
    end
  end
end
