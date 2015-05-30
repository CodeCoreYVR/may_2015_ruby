require 'sinatra'

get '/' do
  erb :fav_songs, layout: :default
end

get '/start-session' do
  erb :session_form, layout: :default
end

post '/start-session' do
  session[:name] = params[:name]
  erb :fav_songs, layout: :default
end
