# Rails CRUD with 5 Song App
Let's create a full crud rails app that displays 5 songs in a table on the home page. We're going to use a PostgreSQL database today.
```
rails new <app-name> -T -d postgresql
```
**note**: `<app-name>` is a required name. You can choose what to put, eg: `five_songs`

## [Generate a Song Model](https://github.com/CodeCoreYVR/may_2015_ruby/commit/ea19efe8a25d0d1f630a2cdf9df8de3738403c02)
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
## [Generate a Songs Controller and Index View](https://github.com/CodeCoreYVR/may_2015_ruby/commit/f6e6d82a86c3e3fdc6c5c1733cde1143c407c14a)
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
## [Add New Songs](https://github.com/CodeCoreYVR/may_2015_ruby/commit/5678fc36fbe43c4eb26ace3fe4050982e2b0dbf3)
Let's add a way for visitors to our site to add new songs. To do this we will need an action in the controller that displays a form. We will also need an action in the controller to handle the form submission, and save the valid song data into the database. We can then choose to redirect to the index view, or somewhere else, if we want.  
  
Let's start by adding the `new` action to our songs controller
```ruby
# app/controllers/songs_controller.rb

class SongsController < ApplicationController
  def index
    @songs = Song.all
  end

  def new
    @song = Song.new
  end
end
```
Now that we have a song instance variable instantiated, and a new action expecting to pass this song instance variable to a new view, let's go ahead and create a new view (we may as well add some routes while we are at it).  
```erb
<% # app/views/songs/new.html.erb %>

<h1>Add a New Favorite Song</h1>

<%= form_for @song do |f| %>
  <%= f.label :title %>: 
  <%= f.text_field :title %><br>
  <%= f.label :artist %>: 
  <%= f.text_field :artist %><br>
  <%= f.label :album %>: 
  <%= f.text_field :album %><br>
  <%= f.label :youtube_link, "watch" %>
  <%= f.text_field :youtube_link %><br>
  <%= f.submit %>
<% end %>
```
Let's add a route for our new song. You'll totally notice, if you actually test it out that only adding a route for getting the new song on your form will break your app. If you haven't yet, test it out! You should be able to figure out why (though, we probably can't yet - don't worry, I didn't know why at first either).
```
Rails.application.routes.draw do
  root "songs#index"
  get "/songs/new" => "songs#new"
end
```
You should see a NoMethodError in Songs#new, something like
```
undefined method `songs_path' for #<#<Class:0x007ff77c0dd380>:0x007ff7813638c0>
```
This is because rails is expecting the route to be formed in a certain way. It is looking for a `songs_path`. We can appease rails in a numberof ways. Here are two:
```ruby
# create whichever route you want, but specify an `as: :something` key-value pair
get "/songs/lol" => "songs#new", as: :songs

# use the path expected by rails, and you can omit specifying the key-value pair.
get "/songs" => "songs#new"
```
## [Add a Create Song Method (and POST route)](https://github.com/CodeCoreYVR/may_2015_ruby/commit/03bcd127eef858f917f4e80ec8c71429bb41c1bd)
Now, when we hit "create song", we can see we're getting an error. This is because no route matches post for our form. We need to add this to our routes file.
```ruby
Rails.application.routes.draw do
  root "songs#index"

  get "/songs" => "songs#new"
  post "/songs" => "songs#create"
end
```
Let's add a controller action for create!
```ruby
class SongsController < ApplicationController
  def index
    @songs = Song.all
  end

  def new
    @song = Song.new
  end

  def create
    @song = Song.new(params.require(:song).
                     permit([:title, :artist, :album, :youtube_link]))
    if @song.save
      flash[:notice] = "Song saved successfully"
      redirect_to root_path
    else
      flash[:alert] = "Something went wrong. Please refresh and try again."
      render :new
    end
  end
end
```
## [Add Navigation](https://github.com/CodeCoreYVR/may_2015_ruby/commit/d0b8b369e7b51d90b8170537707bc82caceec8e)
Let's open up our application layout and add a couple links. We probably want a link to our home page and a link to the add new song page to be available on every page of our site, so let's do that.
```erb
<% # app/views/layouts/application.html.erb %>
<% # ... %>
  <%= link_to "home", root_path %> |
  <%= link_to "add song", songs_path %>
  <%= yield %>

<% # ... %>
```
## [Scoping with Scopes](https://github.com/CodeCoreYVR/may_2015_ruby/commit/241d58bfa3674e214f639e7cb645fd7b74af8121)
Let's create a [rails scope](http://guides.rubyonrails.org/active_record_querying.html#scopes) to select the most recent five songs from the database. We can call it something like `recent_five` and we can use that, instead of `all` when we instantiate the collection of songs that we pass to our index view.  
  
Open up your Song model and add a scope called `recent_five`
```ruby
# app/models/song.rb

class Song < ActiveRecord::Base
  scope :recent_five, -> { order("updated_at DESC").limit(5) }
end
```
Now that we have a scope, let's use it to instantiate the songs collection in our index action.
```ruby
# app/controllers/songs_controller.rb

class SongsController < ApplicationController
  def index
    @songs = Song.recent_five
  end

  # ...

end
```
## [Edit Songs](https://github.com/CodeCoreYVR/may_2015_ruby/commit/602ed391f752e3c0a44945e8b5940af25e88acb1)
Let's add a link beside each song displayed in the index view that allows us to edit it. The link should call an edit action in the songs controller which renders a form that allows us to edit the song. When we submit the form, it should call an update action. **Note**: this is very smilar to `new` and `create`.
```ruby
# app/controllers/songs_controller.rb

class SongsController < ApplicationController

  # ...

  def edit
    @song = Song.find(params[:id])
  end
end
```
Let's add a route that brings up the edit form with the song, based on a param for the song's id.
```ruby
Rails.application.routes.draw do
  root "songs#index"

  get "/songs" => "songs#new"
  post "/songs" => "songs#create"

  get "/songs/:id" => "songs#edit", as: :song
end
```
Since our edit form will have all the same input fields as the new form, we can create a form partial using the form we have, and simply render it on both the new and edit views.
```erb
<% # app/views/songs/_form.html.erb %>

<%= form_for @song do |f| %>
  <%= f.label_for :title %>
  <%= f.text_field :title %><br>
  <%= f.label_for :artist %>
  <%= f.text_field :artist %><br>
  <%= f.label_for :album %>
  <%= f.text_field :album %><br>
  <%= f.label_for :youtube_link, "watch" %>
  <%= f.text_field :youtube_link %><br>
  <%= f.submit %>
<% end %>
```
With a form partial, we can now just call `render :form` in our new and edit views, and not have to repeat the code.
```erb
<% # app/views/songs/new.html.erb %>

<h1>Add a New Favorite Song</h1>

<%= render "form" %>
```
```erb
<% # app/views/songs/edit.html.erb %>

<%= render "form" %>
```
Let's also add a link to edit each song on the index view
```erb
<% # app/views/songs/index.html.erb %>

<h1>Just Five Songs</h1>

<table>
  <tr>
    <th>title</th>
    <th>album</th>
    <th>artist</th>
    <th>watch</th>
    <th>edit</th>
  </tr>
  <% @songs.each do |song| %>
  <tr>
    <td><%= song.title %></td>
    <td><%= song.album %></td>
    <td><%= song.artist %></td>
    <td><%= link_to "watch", song.youtube_link %></td>
    <td><% link_to "edit", song_path(song.id) %></td>
    <td><%= link_to "edit", song %></td>
  <% end %>
</table>
```
## [Update Song](https://github.com/CodeCoreYVR/may_2015_ruby/commit/b4d3ab0f2435712336c245901fa7703438e3ad40)
Now that we have an action to edit questions that renders the form, when we submit the form, it will call the update action in the songs controller. Just like we saved the song in the initial create action, we are going to save it in the update action, however rather than call `save`, we'll call `update`.
```ruby
# app/controllers/songs_controller.rb

class SongsController < ApplicationController

  # ...

  def update
    @song = Song.find(params[:id])

    if @song.update(params.require(:song).
                    permit([:title, :artist, :album, :youtube_link]))
      flash[:notice] = "Song updated successfully"
      redirect_to root_path
    else
      flash[:alert] = "Unable to update song. Please try again."
      render :edit
    end
  end
end
```
We'll also need to add a route to pass a patch request that updates the song in the database.
```ruby
Rails.application.routes.draw do
  root 'songs#index'

  get '/songs' => 'songs#new'
  post '/songs' => 'songs#create'

  get '/songs/:id' => 'songs#edit', as: :song
  patch '/songs/:id' => 'songs#update'
end
```

