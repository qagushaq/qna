Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  concern :votable do
    member { post :vote }
    member { post :revote }
  end

  resources :questions, concerns: [:votable] do
    resources :answers, shallow: true, concerns: [:votable] do
      patch :best, on: :member
    end
  end

  resources :files, only: :destroy
  resources :awards, only: :index

end
