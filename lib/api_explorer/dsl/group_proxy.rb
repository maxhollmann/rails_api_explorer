module ApiExplorer
  class GroupProxy < BaseProxy
    def path(path = nil)
      obj.path = path if path
      obj.path
    end

    def group(title, &block)
      group = Group.new(title)
      proxy = GroupProxy.new(group)
      proxy.collect(&block) if block_given?
      obj.add_child group
    end

    def request(method, path, &block)
      method = method.to_s.downcase.to_sym
      req = Request.new(method, path)
      proxy = RequestProxy.new(req)
      proxy.collect(&block) if block_given?
      obj.add_child req
    end

    def shared(&block)
      proxy = RequestProxy.new(obj)
      proxy.collect(&block)
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
