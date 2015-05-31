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
## Sessions
Let's create a way for visitors to our site to start and stop
sessions. The session should store a visitor's name for the
duration of the session.  
  
To do this, let's create a couple of links on a default layout called _start session_ and _stop session_.
```erb
<% # views/default.erb %>
<!DOCTYPE html>
<html>
  <head>
  </head>
  <body>
    <a href="/start-session">start session</a> |
    <a href="/stop-session">stop session</a>
    <h1>Fav Songs</h1>
    <%= yield %>
  </body>
</html>
```
Let's create a couple of methods in our `fav_songs.rb` to handle get request to `start-session` and `stop-session`.
```ruby
# fav_songs.rb
require 'sinatra'
enable :sessions

get '/' do
  erb :fav_songs, layout: :default
end

get '/start-session' do
  erb :session_form, layout: :default
end

post '/start-session' do
  session[:name] = params[:name]
  redirect '/'
end
```

Now, let's create a form to start new sessions. This form should have an input for a user's name, and another input to submit.
```erb
<% # views/session_form.erb %>
<form action="/start-session" method="post">
  name: <input name="name"><br>
  <input type="submit">
</form>
```
*Note*: Let's add something to output our session to the default layout. This way, we can see what is being set anywhere throughout our app.
```erb
<% # views/default.erb %>
<!DOCTYPE html>
<html>
  <head>
  </head>
  <body>
    <a href="/start-session">start session</a> |
    <a href="/stop-session">stop session</a>
    <h1>Fav Songs</h1>
    <p>Your session is: <%= session.inspect %></p>
    <%= yield %>
  </body>
</html>
```
Let's add a method called `stop_session` that clears a session and redirects back to the root of your app.
```ruby
# fav_songs.rb
require 'sinatra'
enable :sessions

get '/' do
  erb :fav_songs, layout: :default
end

get '/start-session' do
  erb :session_form, layout: :default
end

post '/start-session' do
  session[:name] = params[:name]
  redirect '/'
end

get '/stop-session' do
  session.clear
  # session[:name] = nil # keep other session vars active
  redirect '/'
end
```
Now that we have session handling sorted, let's remove the `session.inspect` line from our default application, and instead have a `logged in as: #{session[:name]` somewhere, if the session has a name value.
```erb
<% # views/default.erb %>
<!DOCTYPE html>
<html>
  <head>
  </head>
  <body>
    <a href="/start-session">start session</a> |
    <a href="/stop-session">stop session</a>
    <% if session[:name] %>
      | logged in as <%= session[:name] %>
    <% end %>
    <h1>Fav Songs</h1>
    <%= yield %>
  </body>
</html>
```
## Add a Song Class
Let's add a way to instantiate songs that we can later add to a session variable `session[:songs]`, which will be a list of songs (_array_ of songs).  
  
There are many ways we _could_ approach this problem, but let's create a song class.
```ruby
# song.rb
class Song
  attr_accessor :artist, :album, :song_name, :youtube_link
  def initialize(artist, album, song_name, youtube_link)
    @artist = artist
    @album = album
    @song_name = song_name
    @youtube_link = youtube_link
  end
end
```
And let's add a view with a form for entering a user's favorite songs.
```erb
<% # views/fav_song_form.erb %>
<h2>Enter One of Your Favorite Songs</h2>
<p>All fields are mandatory!</p>
<form action="/add-song-to-session-songs" method="post">
  artist: <input name="artist"><br>
  album: <input name="album"><br>
  song name: <input name="song-name"><br>
  youtube link: <input name="youtube"><br>
  <input type="submit">
</form>
```
Let's also add a link on the default layout for adding a favorite song.
```erb
<!DOCTYPE html>
<html>
  <head>
  </head>
  <body>
    <a href="/start-session">start session</a> |
    <a href="/stop-session">stop session</a>
    <% if session[:name] %>
      | <a href="/add-song-to-session-songs">add favorite song</a>
      | you are logged in as #{session[:name]}
    <% end %>
    <h1>Fav Songs</h1>
    <%= yield %>
  </body>
</html>
```
Now that we have a form to add songs, and a link to call an action that will render the form, let's actually create the action, and an action to handle the form's post request. _Note_: Make sure to require the song class file as well.
```ruby
# fav_songs.rb
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
  redirect '/'
end

get '/stop-session' do
  session.clear
  # session[:name] = nil # keep other session vars active
  redirect '/'
end

get '/add-song-to-session-songs' do
  erb :fav_song_form, layout: :default
end

post '/add-song-to-session-songs' do
  song = {
    artist: params[:artist],
    album: params[:album],
    song_name: params[:song-name],
    youtube: params[:youtube]
  }
  session[:songs].push(song)
  redirect '/'
end
```
## Add Song Table View
So, we removed the song class, as we decided it was unnecessary. Since we are just adding a hash to the `session[:songs]` array that is instantiated on session start, we don't need a class (we build the hash from the params}.  
  
OK, let's add a table of songs that displays on the `fav_songs` view, if there _are any_ songs in `session[:songs]`.
```erb
<% # views/default.erb %>
<!DOCTYPE html>
<html>
  <head>
  </head>
  <body>
    <a href="/start-session">start session</a> |
    <a href="/stop-session">stop session</a>
    <% if session[:name] %>
      | <a href="/add-song-to-session-songs">add favorite song</a>
      | you are logged in as #{session[:name]}
    <% end %>
    <% if session[:songs] %>
      <% unless session[:songs].lenght == 0 %>
        <table>
         <tr>
           <th>artist</th>
           <th>album</th>
           <th>song name</th>
           <th>youtube</th>
         </tr>
        <% session[:songs].each do |song| %>
         <tr>
           <th><%= song[:artist] %></th>
           <th><%= song[:album] %></th>
           <th><%= song[:song_name] %></th>
           <th><%= song[:youtube] %></th>
         </tr>
        <% end %>
        </table>
      <% end %>
    <% end %>
    <h1>Fav Songs</h1>
    <%= yield %>
  </body>
</html>
```
