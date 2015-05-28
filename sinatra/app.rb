require "sinatra"

# This will be the main application home page
# if we receive a GET request to a '/' URL
# we send back simple text that says "Hello World"
# get "/" do
#   "Hello World"
# end

get "/" do

  # defining an instance variable in here will make it accessible in the
  # ERB file you render after
  @city = "Burnaby"

  # this will render a file called "index.erb" inside the 'views' folder
  # the 'views' folder must in the same directory as this folder.
  # This is called a "convention"
  # passing in a {layout: :application} option will make sinatra look for a file
  # called "application.erb" and inside it look for a <%= yield %> block
  # and then injects the index template in place of the <%= yield %> block
  erb(:index, {layout: :application})
end

get "/greet_me" do
  erb(:greet_me, {layout: :application})
end

post "/greet_me" do
  # any parameters that are sent to the server are captured by Sinatra
  # in an object called "params" and this object is a Hash
  # the keys are the "name" attributes of the form
  # the values are whatever the user has entered in the input fields
  # so if I have a name input as in:
  # <input type="text" id="full_name" name="full_name">
  # I can access it in here by simply doing:
  # params[:full_name]
  @full_name = params[:full_name]
  erb :greet_me_result, layout: :application
end

get "/hello" do
  "Hey There"
end

get "/contact" do
  "Contact Us"
end
