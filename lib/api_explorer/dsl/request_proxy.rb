module ApiExplorer
  class RequestProxy < BaseProxy2
    attr_accessor :description, :headers, :params,
      :excluded_shared_headers

    def initialize(headers = [], params = [])
      self.headers = headers
      self.params  = params
      self.excluded_shared_headers = []
    end

    def exclude_shared_header(name)
      excluded_shared_headers << name
    end

    def desc(description)
      self.description = description
    end

    def param(name, type = nil, options = {}, &block)
      desc = options.fetch(:desc, "")
      if type.nil? && block_given?
        proxy = RequestProxy.new
        proxy.collect(&block)
        params << Parameter.new(name, proxy.params, desc)
      else
        params << Parameter.new(name, type, desc)
      end
    end

    def group(name, options = {}, &block)
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
      headers << Header.new(name, options)
    end
  end
end
