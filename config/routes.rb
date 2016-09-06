Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "ideas#index"

  resources :users, only: [:new, :create, :edit, :update, :show] do
    delete :destroy, on: :collection
  end

  resources :ideas, except: [:index] do
    resources :comments, only: [:create, :edit, :update, :destroy]
    resources :likes, only: [:create, :destroy]
    resources :members, only: [:create, :destroy]
  end

  resources :sessions, only: [:new, :create] do
    delete :destroy, on: :collection
  end

end
