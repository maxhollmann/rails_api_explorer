ApiExplorer::Engine.routes.draw do
  root to: 'explorer#index'
  post 'request' => 'explorer#perform_request'
end
