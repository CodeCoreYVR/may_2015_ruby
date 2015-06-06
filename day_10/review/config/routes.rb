Rails.application.routes.draw do
  root "songs#index"

  get "/songs" => "songs#new"
  post "/songs" => "songs#create"

  get "/songs/:id" => "songs#edit", as: :song
end
