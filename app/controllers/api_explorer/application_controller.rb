class ApiExplorer::ApplicationController < ApplicationController
  before_filter do
    ApiExplorer.auth.call(self) if ApiExplorer.auth
  end
end
