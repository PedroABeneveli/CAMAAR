Rails.application.routes.draw do
  devise_for :users
  get "/student_forms", to: "student_forms#index"
  root to: "home#index"
end
