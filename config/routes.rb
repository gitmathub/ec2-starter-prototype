Rails.application.routes.draw do
  get 'instances/index'

  # add to the 7 generic routes self defined ("member") routes
  resources :instances do
    member do
      get 'start'
    end
  end


  root 'instances#index'
end
