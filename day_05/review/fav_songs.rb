require 'sinatra'
require './song.rb'

enable :sessions

get '/' do
  erb :fav_songs, layout: :default
end

get '/start-session' do
  erb :session_form, layout: :default
end

post '/start-session' do
  session[:name] = params[:name]
  session[:songs] = []
  # erb :fav_songs, layout: :default
  redirect '/'
end

get '/stop-session' do
  session.clear
  redirect '/'
end

get '/add-song-to-session-songs' do
  erb :fav_song_form, layout: :default
end

post '/add-song-to-session-songs' do
  song = {
    artist: params[:artist],
    album: params[:album],
    song_name: params[:name],
    youtube: params[:youtube]
  }
  session[:songs].push(song)
  redirect '/'
end
