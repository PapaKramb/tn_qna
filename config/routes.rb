Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    resources :answers, except: %i[index, show], shallow: true do
      patch :best_answer, on: :member
    end
  end
  resources :files, only: :destroy
end
