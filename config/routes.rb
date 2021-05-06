Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

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

  resources :questions, concerns: :votable do
    resources :answers, concerns: :votable, except: %i[index, show], shallow: true do
      patch :best_answer, on: :member
    end
  end

  resources :files, only: :destroy

  resources :links, only: :destroy

  mount ActionCable.server => '/cable'
end
