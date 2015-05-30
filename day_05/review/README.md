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
