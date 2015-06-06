# Rails CRUD with 5 Song App
Let's create a full crud rails app that displays 5 songs in a table on the home page. We're going to use a PostgreSQL database today.
```
rails new <app-name> -T -d postgresql
```
**note**: `<app-name>` is a required name. You can choose what to put, eg: `five_songs`

## Generate a Song Model
Let's start by generating a song model with the following attributes: title, artist, album, and youtube link. You may notice that all of these attributes are strings. By default, rails uses the string datatype for model attributes, so we do not need to explicitly state the datatype in our model generation. However, we will.  
```
rails generate model song title:string artist:string album:string youtube_link:string
```
That is, this would be the exact same thing as the above statement
```
rails generate model song title artist album youtube_link
```
If we want to be able to create new songs, we must first make sure that
we have a database, and that we have run our migrations.
```
bin/rake db:create db:migrate
```
Now, we should be able to hop into rails console and create some songs.
Before we do this, let's add the [hirb gem](https://github.com/cldwalker/hirb) to our Gemfile.
```ruby
# ...
  group :development do
    # ...
    gem 'hirb'
    # ...
  end
# ...
```
Let's hop into `rails console` and create a song.
```
rails console
song = Song.new
song.title = "Heavy Metal"
song.artist = "White Rabbits"
song.album = "Milk Famous"
song.youtube_link = "https://www.youtube.com/watch?v=M8Rk2lDZJhU"
song.save
```
We can also create songs in one step, like this:
```
Song.create(title: "Heavy Metal", artist: "White Rabbits", album: "Milk Famous", youtube_link: "https://www.youtube.com/watch?v=M8Rk2lDZJhU")
```
## Generate a Songs Controller and Index View
Now, we'll generate a controller for our songs. This is going to have an index action which will instantiate a variable which is a collection of all the songs in the database. We will pass this variable to our index view to display the songs that we want.
```
rails generate controller songs
```
Let's open up the `songs_controller.rb` and add an index action
```ruby
# app/controllers/songs_controller.rb

class SongsController < ApplicationController
  def index
    @songs = Song.all
  end
end
```
Now that we have an instance variable which is a collection of all the songs being passed to a view, we can create the view to view.
```erb
<% # app/views/songs/index.html.erb %>

<h1>Just Five Songs</h1>

<table>
  <tr>
    <th>title</th>
    <th>album</th>
    <th>artist</th>
    <th>watch</th>
  </tr>
  <% @songs.each do |song| %>
  <tr>
    <td><%= song.title %></td>
    <td><%= song.album %></td>
    <td><%= song.artist %></td>
    <td><%= link_to "watch", song.youtube_link %></td>
  </tr>
  <% end %>
</table>
```
Let's add a route to `config/routes.rb` to display the songs index view as the root route for our app
```ruby
# config/routes.rb
Rails.applications.routes.draw do
  root "songs#index"
end
```
