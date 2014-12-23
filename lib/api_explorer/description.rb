require 'httparty'

module ApiExplorer
  class Request
    attr_accessor :method, :path, :params, :headers

    def initialize(method, path, params = [], headers = [])
      self.method  = method.to_s
      self.path    = path.to_s
      self.params  = Array(params)
      self.headers = Array(headers)
    end

    def url
      ApiExplorer.base_url + path
    end

    def url_params
      path.scan(/:[a-zA-Z_\-]+/).map { |s| s[1..s.size] }
    end

    def perform(params = {}, headers = {})
      RequestPerformer.new(self).perform(params, headers)
    end
  end

  class Parameter
    def initialize(name, type_or_children)
      self.name = name.to_s
      if type_or_children.is_a?(Array)
        self.type = :hash
        self.children = type_or_children
      else
        self.type = type_or_children.to_sym
      end
    end

    attr_accessor :name, :type, :children
  end

  class Header
    def initialize(name)
      self.name = name.to_s
    end

    attr_accessor :name
  end

  class Description
    attr_accessor :requests

    def initialize(requests)
      self.requests = requests
    end

    def find_request(method, path)
      requests.each do |req|
        return req if req.method.to_s == method.to_s && req.path.to_s == path.to_s
      end
      nil
    end
  end

  class RequestPerformer
    include HTTParty
    format :json

    attr_accessor :request

    def initialize(request)
      self.request = request
    end

    def perform(params = {}, headers = {})
      send(request.method, ApiExplorer.base_url + request.path, params.merge(format: :json), headers)
    end

    def post(path, params, headers)
      self.class.post path, body: params, headers: headers
    end

    def get(path, params, headers)
      self.class.get path, query: params, headers: headers, format: :json
    end
  end

  class Response
    attr_accessor :json

    def initialize(json)
      self.json = CallableJSON.new(json)
    end

    def method_missing(key, *args)
      json.send key
    end

    class CallableJSON
      attr_accessor :json

      def initialize(json)
        self.json = json
      end

      def method_missing(key)
        CallableJSON.new(json[key.to_s])
      end
    end
  end
end
