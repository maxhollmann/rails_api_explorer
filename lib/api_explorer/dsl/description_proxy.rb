module ApiExplorer
  class DescriptionProxy < BaseProxy
    def methods
      Methods
    end

    class Methods
      def self.request(method, path, &block)
        if block_given?
          proxy = RequestProxy.new(ApiExplorer.global_headers + ApiExplorer.global_params)
          proxy.collect(&block)
          params = proxy.params
          headers = proxy.headers
          desc = proxy.description
        else
          params = ApiExplorer.global_params
          headers = ApiExplorer.global_headers
          desc = ""
        end
        Request.new(method, path, params, headers, desc)
      end

      def self.global(&block)
        proxy = RequestProxy.new
        proxy.collect(&block)
        ApiExplorer.global_headers = proxy.headers.map { |h| h.global = true; h }
        ApiExplorer.global_params = proxy.params.map { |p| p.global = true; p }
        nil
      end

      def self.get(path, &block)
        request(:get, path, &block)
      end
      def self.post(path, &block)
        request(:post, path, &block)
      end
      def self.put(path, &block)
        request(:put, path, &block)
      end
      def self.patch(path, &block)
        request(:patch, path, &block)
      end
      def self.delete(path, &block)
        request(:delete, path, &block)
      end
    end
  end
end
