Rails.application.routes.draw do
  namespace :api do
    post "users/sign_in" => "session#create"
    resources :posts
  end

  mount ApiExplorer::Engine => "/"
end
