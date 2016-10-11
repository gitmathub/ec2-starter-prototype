Rails.application.routes.draw do
  get 'instances/index'
  resources :instances
  root 'instances#index'
end
