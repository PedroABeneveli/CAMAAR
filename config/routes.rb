Rails.application.routes.draw do
  devise_for :users

  resources :avaliacoes, only: [:index] do
    resources :response, only: [:index, :create, :update, :destroy]
  end

  scope :gerenciamento do
    put 'import', :to => 'gerenciamento#import', :as => 'gerenciamento_import'

    resources :resultados, only: [:index] do
      member do
        get :export, :as => "resultados_export"
      end
    end

    resources :send_forms, only: [:index, :create]

    resources :templates, only: [:index, :new, :create, :edit, :update, :destroy]
  end

  get '/gerenciamento', to: 'gerenciamento#index'

  root to: "avaliacoes#index"
end
