module ApiExplorer
  class GroupProxy < BaseProxy
    attr_accessor :children, :shared_headers, :shared_params, :path

    def initialize
      self.children       = []
      self.shared_headers = []
      self.shared_params  = []
    end

    def path(path = nil)
      self.path = path if path
      @path
    end

    def request(method, path, &block)
      method = method.to_s.downcase.to_sym
      proxy = RequestProxy.new
      proxy.collect(&block) if block_given?
      children << Request.new(method, path,
                              proxy.params, proxy.headers,
                              proxy.description,
                              proxy.excluded_shared_headers)
    end

    def shared(&block)
      proxy = RequestProxy.new
      proxy.collect(&block)
      self.shared_headers = proxy.headers
      self.shared_params  = proxy.params
    end

    def get(path, &block)
      request(:get, path, &block)
    end
    def post(path, &block)
      request(:post, path, &block)
    end
    def put(path, &block)
      request(:put, path, &block)
    end
    def patch(path, &block)
      request(:patch, path, &block)
    end
    def delete(path, &block)
      request(:delete, path, &block)
    end
  end
end
