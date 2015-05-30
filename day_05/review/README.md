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
## Add Views
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
