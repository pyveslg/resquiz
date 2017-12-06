Rails.application.routes.draw do

  root to: 'quizzes#index'

  resources :decks, param: :path, only: [:index, :show] do
    member do
      get 'replay', to: "decks#replay"
    end
  end
  resources :flashcards, param: :slug, only: [:show]
  resources :played_cards, only: [:create]

  resources :quizzes, only: [:index, :show]
  resources :quizzes do
    member do
      get 'retake', to: "quizzes#retake"
    end
  end
  resources :questions, only: [:show]
  resources :questions do
    resources :answers, only: [:create, :update, :destroy]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
