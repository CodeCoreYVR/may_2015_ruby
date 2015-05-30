require 'sinatra'

get '/' do
  erb :form
end

post '/' do
  "<h1>Thank you #{params[:name]}!</h1>
  <p>Your email address is #{params[:email]}</p>"
  # erb :thank_you
end

post '/haha' do
  "hahahahahaha!"
end
