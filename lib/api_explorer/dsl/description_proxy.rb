module ApiExplorer
  class DescriptionProxy < BaseProxy2
    attr_accessor :requests, :shared_headers, :shared_params

    def initialize
      self.requests       = []
      self.shared_headers = []
      self.shared_params  = []
    end

    def request(method, path, &block)
      proxy = RequestProxy.new
      proxy.collect(&block) if block_given?
      requests << Request.new(method, path,
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
