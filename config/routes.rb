Rails.application.routes.draw do

  root to: 'quizzes#index'
  resources :quizzes, only: [:index, :show]
  resources :quizzes do
    member do
      get 'retake', to: "quizzes#delete_answers"
    end
  end
  resources :questions, only: [:show]
  resources :questions do
    resources :answers, only: [:create, :update, :destroy]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
