class ApiExplorer::ApplicationController < ApplicationController
  before_filter do
    instance_eval(&ApiExplorer.auth) if ApiExplorer.auth
  end
end
