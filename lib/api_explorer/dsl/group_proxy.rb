module ApiExplorer
  class GroupProxy < BaseProxy
    def path(path = nil)
      obj.path = path if path
      obj.path
    end

    def request(method, path, &block)
      method = method.to_s.downcase.to_sym
      proxy = RequestProxy.new
      proxy.collect(&block) if block_given?
      obj.add_child Request.new(method, path,
                                proxy.params, proxy.headers,
                                proxy.description,
                                proxy.excluded_shared_headers)
    end

    def shared(&block)
      proxy = RequestProxy.new
      proxy.collect(&block)
      obj.shared_headers = proxy.headers
      obj.shared_params  = proxy.params
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
