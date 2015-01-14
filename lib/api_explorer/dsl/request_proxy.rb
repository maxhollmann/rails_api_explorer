module ApiExplorer
  class RequestProxy < BaseProxy
    attr_accessor :description

    def methods
      Methods
    end

    def params
      out.select { |o| o.is_a?(Parameter) }
    end
    def headers
      out.select { |o| o.is_a?(Header) }
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

    def desc(description)
      self.description = description
    end

    class Methods
      def self.param(name, type = nil, options = {}, &block)
        desc = options.fetch(:desc, "")
        if type.nil? && block_given?
          proxy = RequestProxy.new
          proxy.collect(&block)
          Parameter.new(name, proxy.params, desc)
        else
          Parameter.new(name, type, desc)
        end
      end

      def self.group(name, options = {}, &block)
        param(name, nil, options, &block)
      end
      def self.string(name, options = {}, &block)
        param(name, :string, options)
      end
      def self.boolean(name, options = {}, &block)
        param(name, :boolean, options)
      end
      def self.integer(name, options = {}, &block)
        param(name, :integer, options)
      end

      def self.header(name, options = {})
        Header.new(name, options)
      end
    end
  end
end
