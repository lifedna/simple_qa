SimpleQa::Application.routes.draw do
  resources :questions do
    member do
      get :vote_up
      get :vote_down
      get :unvote
    end
    
    resources :answers do
      member do
        get :vote_up
        get :vote_down
        get :unvote
      end
    end
  end

  root :to => "questions#index"

  devise_for :users
end
