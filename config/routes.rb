Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  resources :questions do
    resources :answers, shallow: true do
      patch :best, on: :member
    end
  end

end
