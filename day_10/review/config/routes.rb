Rails.application.routes.draw do
  root "songs#index"

  get "/songs" => "songs#new"
  post "/songs" => "songs#create"

  get "/songs/:id" => "songs#edit", as: :song
  patch "/songs/:id" => "songs#update"

  resources :artists, only: [:new, :create, :show, :index] do
    resources :albums, only: [:create]
  end

  resources :albums, only: [:index, :show] do
    resources :songs, only: [:create, :destroy]
  end

  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create] do
    delete :destroy, on: :collection
  end

end
