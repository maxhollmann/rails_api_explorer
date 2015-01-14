module ApiExplorer
  class Request
    attr_accessor :method, :path, :params, :headers, :description

    def initialize(method, path, params = [], headers = [], description = "")
      self.method      = method.to_s
      self.path        = path.to_s
      self.params      = Array(params)
      self.headers     = Array(headers)
      self.description = description
    end

    def url
      ApiExplorer.base_url + path
    end

    def url_params
      path.scan(/:[a-zA-Z_\-]+/).map { |s| s[1..s.size] }
    end

    def url_segments
      path.scan(/(:[a-zA-Z_\-]+)|([^:]+)/).map do |param, normal|
        if param
          [:param, param[1..param.size]]
        else
          [:normal, normal]
        end
      end
    end

    def perform(params = {}, headers = {})
      RequestPerformer.new(self).perform(params, headers)
    end
  end
end
