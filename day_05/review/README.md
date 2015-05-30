#Fav Songs
Sample Sinatra app using sessions to store user data and list a user's favorite songs. *Note*: Nothing will be saved once the session is destroyed.
## Getting Started
Let's begin by building the classic, "Hello World" in Sinatra to make sure we start with a working application.  
  
First of all, create a new file called "fav_songs.rb". You can create it like this: `touch fav_songs.rb`. Open it up in your favorite text editor, require the sinatra gem, and add a method to render the text "Hello World" when a get request is performed on the root of your app.  
```ruby
# fav_songs.rb
require 'sinatra'

get '/' do
  "Hello World"
end
```
## Add Views and Layouts
Instead of having a get request on the root of our app simply render some text, let's have it use a view instead. In order to use views in Sinatra, we need to create a directory called _views_.  
  
We can add as many views as we'd like in our views directory. View files will use ERB, and should have the `.erb` extension. To use a view, we simply call it from the desired method. For example, if we create a view called `fav_songs.erb` we can call it in our get request method for our root directory like so:
```ruby
# fav_songs.rb
require 'sinatra'

get '/' do
  erb :fav_songs
end
```
*Note*: we call the view with a symbol, and do not specify its
extension, `erb :fav_songs`  
  
Let's also make the views directory, and a view called `fav_songs.erb` that simply displays the text _Hello World_.
```erb
<% # views/fav_songs.erb %>
Hello World

```  
We can also add a layout, which we can call for all of our views. This is especially useful when we want to include something for all, or several pages on our site, such as a navigation bar.  
  
Let's create a layout called `default.erb` and call it in the method for the get request for our home page.  
  
Start by creating a file in your views directory called `default.erb`. We will add a ruby method called `yield` to render the other views within the default layout.  
```erb
<% # views/default.erb %>
<!DOCTYPE html>
<html>
  <head>
  </head>
  <body>
    <h1>Fav Songs</h1>
    <%= yield %>
  </body>
</html>
```
Next, call the layout in the method in `fav_songs.rb` that handles get requests to the root of your app.
```ruby
# fav_songs.rb
require 'sinatra'

get '/' do
  erb :fav_songs, layout: :default
end
```
