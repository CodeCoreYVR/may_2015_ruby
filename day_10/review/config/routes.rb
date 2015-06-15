Rails.application.routes.draw do
  root "songs#index"

  get "/songs" => "songs#new"
  post "/songs" => "songs#create"

  get "/songs/:id" => "songs#edit", as: :song
  patch "/songs/:id" => "songs#update"

  resources :artists, only: [:new, :create, :show] do
    resources :albums, only: [:create]
  end

  resources :albums, only: [:index, :show] do
    resources :songs, only: [:create, :destroy]
  end

end
