require_dependency "api_explorer/application_controller"

module ApiExplorer
  class ExplorerController < ApplicationController
    def index
      @description = ApiExplorer.description
    end

    def perform_request
      rp = params.require(:request)
      req = ApiExplorer.description.find_request(rp[:method], rp[:path])
      @response = ApiExplorer::RequestPerformer.new(req).perform(rp[:params])
    end
  end
end
