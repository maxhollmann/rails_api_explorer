require "api_explorer/engine"
require "api_explorer/node"
require "api_explorer/group"
require "api_explorer/description"
require "api_explorer/header"
require "api_explorer/parameter"
require "api_explorer/request"
require "api_explorer/dsl"

module ApiExplorer
  mattr_accessor :description, :auth

  def self.describe(&block)
    self.description = Description.new("", "", [], [], [])
    proxy = DescriptionProxy.new(description)
    proxy.collect(&block)
    #self.description = Description.new(proxy.path, proxy.children, proxy.shared_headers, proxy.shared_params)
  end
end
