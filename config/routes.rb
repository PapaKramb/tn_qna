require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => 'sidekiq'
  end

  use_doorkeeper
  devise_for :users
  root to: 'questions#index'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show create destroy update] do
        resources :answers, only: %i[index show create destroy update], shallow: true
      end
    end
  end

  resources :users do
    get :rewards, on: :member
  end

  concern :votable do
    member do
      post :vote_up
      post :vote_down
      delete :delete_vote
    end
  end

  concern :commentable do
    resources :comments, shallow: true, only: %i[create]
  end

  resources :questions, concerns: %i[votable commentable] do
    resources :answers, concerns: %i[votable commentable], except: %i[index, show], shallow: true do
      patch :best_answer, on: :member
    end
    resources :subscribes, shallow: true, only: %i[create destroy]
  end

  resources :files, only: :destroy

  resources :links, only: :destroy

  mount ActionCable.server => '/cable'
end
