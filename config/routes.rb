Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :fixtures, only: [] do
    get :head_to_head, on: :collection
  end
end
