module ApiExplorer
  class Request < Node
    attr_accessor :method, :params, :headers, :description, :excluded_shared_headers

    def initialize(method, path, params = [], headers = [], description = "", excluded_shared_headers = [])
      super nil, nil, path

      self.method                  = method.to_s
      self.params                  = Array(params)
      self.headers                 = Array(headers)
      self.description             = description
      self.excluded_shared_headers = Array(excluded_shared_headers)
    end

    def url
      full_path
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

    def title
      "#{method.upcase} #{path}"
    end
  end
end
