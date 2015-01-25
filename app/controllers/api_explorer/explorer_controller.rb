require_dependency "api_explorer/application_controller"

module ApiExplorer
  class ExplorerController < ApplicationController
    def index
      @description = ApiExplorer.description
    end
  end
end
