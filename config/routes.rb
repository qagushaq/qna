Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks',
                                    confirmations: 'confirmations' }

  concern :votable do
    member { post :vote }
    member { post :revote }
  end

  resources :questions, concerns: [:votable] do
    resources :comments, only: [:create]
    resources :answers, shallow: true, concerns: [:votable] do
      patch :best, on: :member
      resources :comments, only: [:create]
    end
  end

  resources :files, only: :destroy
  resources :awards, only: :index


  devise_scope :user do
    match 'users/:id/confirm_email' => 'oauth_callbacks#confirm_email', via: [:get, :patch], as: :confirm_email
  end

  mount ActionCable.server => '/cable'

end
