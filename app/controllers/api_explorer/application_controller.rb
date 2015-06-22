class ApiExplorer::ApplicationController < ApplicationController
  layout "api_explorer"

  before_filter do
    instance_eval(&ApiExplorer.auth) if ApiExplorer.auth
  end
end
