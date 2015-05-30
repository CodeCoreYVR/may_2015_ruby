require 'sinatra'

get '/' do
  erb :fav_songs, layout: :default
end
