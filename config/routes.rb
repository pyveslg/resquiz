Rails.application.routes.draw do

  root to: 'quizzes#index'
  resources :quizzes, only: [:index, :show]
  resources :questions, only: [:show]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
