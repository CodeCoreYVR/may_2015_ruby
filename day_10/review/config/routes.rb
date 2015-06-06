Rails.application.routes.draw do
  root "songs#index"

  get "/songs" => "songs#new"
end
