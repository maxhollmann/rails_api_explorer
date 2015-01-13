require "api_explorer/engine"
require "api_explorer/description"

module ApiExplorer
  mattr_accessor :description, :base_url, :global_headers, :global_params

  def self.describe(&block)
    proxy = RequestsProxy.new
    proxy.collect(&block)
    self.description = Description.new(proxy.out.compact)
  end

  class ArrayProxy
    attr_accessor :out

    def initialize(objects = [])
      self.out = Array(objects.clone)
    end

    def collect(&block)
      instance_eval(&block)
    end

    def use_header(name)
      obj = ApiExplorer.global_headers.find { |h| h.name == name }
      out << obj if obj && !out.include?(obj)
    end
    def use_param(name)
      obj = ApiExplorer.global_params.find { |p| p.name == name }
      out << obj if obj && !out.include?(obj)
    end

    def dont_use_header(name)
      obj = ApiExplorer.global_headers.find { |h| h.name == name }
      out.delete(obj)
    end

    def method_missing(method, *args, &block)
      out << methods.send(method, *args, &block)
    end
  end

  class RequestsProxy < ArrayProxy
    def methods
      Methods
    end

    class Methods
      def self.request(method, path, &block)
        if block_given?
          proxy = ParamsProxy.new(ApiExplorer.global_headers + ApiExplorer.global_params)
          proxy.collect(&block)
          params = proxy.params
          headers = proxy.headers
        else
          params = ApiExplorer.global_params
          headers = ApiExplorer.global_headers
        end
        Request.new(method, path, params, headers)
      end

      def self.global(&block)
        proxy = ParamsProxy.new
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

  class ParamsProxy < ArrayProxy
    def methods
      Methods
    end

    def params
      out.select { |o| o.is_a?(Parameter) }
    end
    def headers
      out.select { |o| o.is_a?(Header) }
    end

    class Methods
      def self.param(name, type = nil, &block)
        if type.nil? && block_given?
          proxy = ParamsProxy.new
          proxy.collect(&block)
          Parameter.new(name, proxy.params)
        else
          Parameter.new(name, type)
        end
      end

      def self.group(name, &block)
        param(name, nil, &block)
      end
      def self.string(name, &block)
        param(name, :string)
      end
      def self.boolean(name, &block)
        param(name, :boolean)
      end
      def self.integer(name, &block)
        param(name, :integer)
      end

      def self.header(name, options = {})
        Header.new(name, options)
      end
    end
  end

end
