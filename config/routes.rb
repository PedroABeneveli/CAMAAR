Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root 'session#login'

  get 'login', to: 'session#login'
  post 'login', to: 'session#create'
  delete 'logout', to: 'session#destroy'

  # Defines the root path route ("/")
  # root "posts#index"
end
