require "api_explorer/engine"
require "api_explorer/description"
require "api_explorer/header"
require "api_explorer/parameter"
require "api_explorer/request"
require "api_explorer/dsl"

module ApiExplorer
  mattr_accessor :description, :base_url, :shared_headers, :shared_params, :auth

  def self.describe(&block)
    proxy = DescriptionProxy.new
    proxy.collect(&block)
    self.description = Description.new(proxy.requests, proxy.shared_headers, proxy.shared_params)
  end
end
