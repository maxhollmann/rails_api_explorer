module ApiExplorer
  class RequestProxy < BaseProxy
    def exclude_shared_header(name)
      obj.excluded_shared_headers << name
    end

    def desc(description)
      obj.description = description
    end

    def param(name, type = nil, options = {}, &block)
      desc = options.fetch(:desc, "")
      if type.nil? && block_given?
        param = Parameter.new(name, [], desc)
        param.type = :hash
        proxy = RequestProxy.new(param)
        proxy.collect(&block)
        obj.params << param
      else
        obj.params << Parameter.new(name, type, desc)
      end
    end

    def struct(name, options = {}, &block)
      param(name, nil, options, &block)
    end
    def string(name, options = {}, &block)
      param(name, :string, options)
    end
    def boolean(name, options = {}, &block)
      param(name, :boolean, options)
    end
    def integer(name, options = {}, &block)
      param(name, :integer, options)
    end

    def header(name, options = {})
      obj.headers << Header.new(name, options)
    end
  end
end
