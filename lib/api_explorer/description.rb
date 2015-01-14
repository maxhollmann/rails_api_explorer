module ApiExplorer
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
end
