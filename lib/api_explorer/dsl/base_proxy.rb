module ApiExplorer
  class BaseProxy
    attr_accessor :out

    def initialize(objects = [])
      self.out = Array(objects.clone)
    end

    def collect(&block)
      instance_eval(&block)
    end

    def method_missing(method, *args, &block)
      out << methods.send(method, *args, &block)
    end
  end
end
