module ApiExplorer
  class Description
    attr_accessor :requests, :shared_headers, :shared_params

    def initialize(requests, shared_headers, shared_params)
      self.requests       = requests
      self.shared_headers = shared_headers
      self.shared_params  = shared_params
    end

    def find_request(method, path)
      requests.each do |req|
        return req if req.method.to_s == method.to_s && req.path.to_s == path.to_s
      end
      nil
    end
  end
end
