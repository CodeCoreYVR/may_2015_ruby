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
## [One to Many (Artists have Many Albums)](https://github.com/CodeCoreYVR/may_2015_ruby/commit/d9c4c35a7b4d5c5c651c3fcab1ebbf32abe9cb3d)
Let's create a couple of [one to many](http://guides.rubyonrails.org/association_basics.html) relations. When we look at our Song model, there are some obvious one to many relations that can be made. The ones that may make the most sense at first (or at least for today) are that artists may have many albums (albums belong to artists), and albums have many songs (songs belong to albums). Let's start with the former!  
  
To make a one to many relation between artists and albums, we are going to need artist and album models. So, let's create them.  
  
What attributes should our artist have? Let's keep things simple, and
use artist to mean group, band, solo artist, or whatever we have.  
```
rails generate model artist name:string
```
Now, if artists are going to have many albums, we will also want to have a album model. What attributes should our album model have? Let's also keep things simple with albums and give them an artist reference, a name, and a release year.
```
rails generate model album name:string release_year:datetime artist:references
```
Now that we have a couple of models generated, let's open up the class files and add the appropriate associations.  
  
Add a `has_many` relation to the artist model
```ruby
# app/models/artist.rb
class Artist < ActiveRecord::Base
  has_many :albums
end
```
And open up your album model, and you should see the `belongs_to` association is already there (this is because we added `artist:references` to the model generation).
```ruby
class Album < ActiveRecord::Base
  belongs_to :artist
end
```
Before running a migration, open up the album migration file, and have a look at the refences line. It add `index: true` which creates an `artist_id` field for all new albums.
```ruby
class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :name
      t.datetime :release_year
      t.references :artist, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
```
Run `bin/rake db:migrate` and open up rails console to play around with your new models.  
  
Let's make a few new artists.
```shell
Artist.create(name: "White Rabbits")
Artist.create(name: "Summer Heart")
Artist.create(name: "Throw Me the Statue")
```
Now that we have some artists, let's make some albums for them. Note, that because of the relationships we have set up, rather than using `album.new` we will use `artist.albums.new` like this
```shell
a = Artist.first
album = a.albums.new
```
When we instantiate an album this way, it pre-populates the artist id
attributes with the artist's id.

## [One to Many (Albums have Many Songs)](https://github.com/CodeCoreYVR/may_2015_ruby/commit/6243d65dc2368866253139bd7fe5a2f715581af0)
We already have a song model, and it has an album attribute. This is currently a string. Today, we're going to drop this column, then add a new column. **Bonus**: Read the rails documentation to find a way to do this in one step.
```shell
rails generate migration drop_column_album_from_songs
```
Open up the migration file and remove the appropriate column.
```ruby
class DropColumnAlbumFromSongs < ActiveRecord::Migration
  def change
    remove_column :songs, :album
  end
end
```
Now, let's add album references to songs
```shell
rails generate migration add_album_references_to_songs album:refenences
```
We also want to add `has_many` and `belongs_to`, so let's open up the
models and do that
```ruby
# app/models/album.rb
class Album < ActiveRecord::Base
  belongs_to :artist
  has_many :songs
end
```
```ruby
class Song < ActiveRecord::Base
  belongs_to :album
end
```
Run a `bin/rake db:migrate` and let's open up the console to see if it worked!  
  
We will have a look at how to make new songs next time. Keep in mind that our app no longer works on the front end! See if you can _fix_ it.
## [Change Column Data Type](https://github.com/CodeCoreYVR/may_2015_ruby/commit/6243d65dc2368866253139bd7fe5a2f715581af0)
Let's change the album field `release_date` to a string. To do this, let's first generate a migration that removes the column.
```
rails generate migration remove_column_release_date_from_album release_date:datetime
```
This will generate a migration file that looks like this
```ruby
class RemoveColumnReleaseYearFromAlbum < ActiveRecord::Migration
  def change
    remove_column :albums, :release_year, :datetime
  end
end
```
We know that we want to add a column of type string, so what will happen if we add a line to the migration that just adds that column?
```ruby
class RemoveColumnReleaseYearFromAlbum < ActiveRecord::Migration
  def change
    remove_column :albums, :release_year, :datetime
    add_column :albums, :release_year, :string
  end
end
```
**Bonus**: See if you can find a _better_ way to accomplish the same thing.  

## [add artist references to songs](https://github.com/CodeCoreYVR/may_2015_ruby/commit/1a48ce74debddc6e8097b08dd6b6126b5326a593)
Now, let's make sure our songs have `album_id` and `artist_id` fields that reference albums and artists. Since we're going to do this, we no longer need the artist column, so let's remove it.
```
bin/rails generate migration remove_column_artist_from_songs artist:string
```
Let's generate another migration to add artist references
```
bin/rails generate migration add_artist_references_to_songs artist:references
```
After generating these migrations, run `bin/rake db:migrate` and check them out in `bin/rails console` and let's go through the steps of creating a new song.
```
@artist = Artist.last
@album = @artist.albums.last
@song = @album.songs.new
@song.artist_id = @album.artist.id
@song.youtube_link = "https://www.youtube.com/watch?v=TzjPP1jH6_k"
@song.title = "Breathing"
@song.save
```
Try firing up your `bin/rails server` and you should see a nice big error on your home page!
## [Fix the Index View](https://github.com/CodeCoreYVR/may_2015_ruby/commit/ab9fc74c2f6a3ff5cad7369e668c7a5e99698b0a)
The song index view is broken, because we no longer have a column "artist", also our album field is showing an object, rather than a string or a link. Let's fix this up first by just getting our index to show the string names of albums and artists.
```erb
<% # app/views/songs/index.html.erb %>

<% ... %>

  <% @songs.each do |song| %>
    <tr>
      <td><%= song.title %></td>
      <td><%= song.album.name %></td>
      <td><%= song.album.artist.name %></td>
      <td><%= link_to "watch", song.youtube_link %></td>
      <td><%= link_to "edit", song_path(song.id) %></td>
    </tr>
  <% end %>

<% ... %>
```
## [Artist Routes, Views, and Controller](https://github.com/CodeCoreYVR/may_2015_ruby/commits/master)
Let's start by making a route that will lead to a view with a form for creating a new artist.
```ruby
# config/routes.rb
Rails.application.routes.draw do

# ...
  resources :artists, only: [:new, :create]
# ...
end
```
Let's add a `add artist` link to our navigation bar
```erb
<!-- app/views/layouts/application.html.erb -->

  <%= link_to "home", root_path %> |
  <%= link_to "add song", songs_path %> |
  <%= link_to "add artist", new_artist_path %>

```
Add a controller with a `new` action to handle the link. The `new` action should instantiate a new artist and pass it to the new view.
```ruby
# app/controllers/artists_controller.rb

class ArtistsController < ApplicationController
  def new
    @artist = Artist.new
  end
end
```
We can now create a view with a form for adding new artists
```erb
<%# app/views/artists/new.html.erb %>

<h1>New Artist</h1>

<%= form_for @artist do |f| %>
  <%= f.label :name %><br>
  <%= f.text_field :name %><br>
  <%= f.submit %>
<% end %>

```
When we hit submit, Rails will be looking for a create action. Let's _create_ a create action!
```ruby
class ArtistsController < ApplicationController
  def new
    @artist = Artist.new
  end

  def create
    @artist = Artist.new(params.require(:artist).permit([:name]))
    if @artist.save
      redirect_to artist_path(@artist.id)
      flash[:notice] = "Artist saved!"
    else
      render :new
      flash[:alert] = "Artist not saved!"
    end
  end
end
```
Also, add show to the artist resources array in routes `resources :artists, only: [:new, :create, :show]`  
  
We will also want to add a view.
```erb
<% # app/views/artists/show.html.erb %>

<h1><%= @artist.name %><h1>

<table>
  <tr>
    <th>name</th>
    <th>release year</th>
    <th>view songs</th>
  </tr>
  <% @artist.albums.each do |album| %>
    <tr>
      <td><%= album.name %></p></td>
      <td><%= album.release_year %></td>
      <td>show album</td>
    </tr>
  <% end %>
</table>
```
Now, let's add a link to our songs index page back to the artist view.
```erb
<% # app/views/songs/index.html.erb %>

  <% @songs.each do |song| %>
    <tr>
      <td><%= song.title %></td>
      <td><%= song.album.name %></td>
      <td><%= link_to song.album.artist.name, song.album.artist %></td>
      <td><%= link_to "watch", song.youtube_link %></td>
      <td><%= link_to "edit", song_path(song.id) %></td>
    </tr>
  <% end %>
```
## [Album Routes, Views, and Controller](https://github.com/CodeCoreYVR/may_2015_ruby/commit/20dbcb505e396e6e854609da25428e2e57d5a026)
let's create some route resources for albums
```ruby
# config/routes.rb

Rails.application.routes.draw do
  # ...

  resources :albums, only: [:new, :create, :show]

  #...
end
```
Add the controller and actions. We're going to add the form to the artist show page, so we'll want to instantiate a new album in the show action in the artists controller.
```ruby
# app/controllers/artists_controller.rb

  # ...
  def show
    @artist = Artist.find(params[:id])
    @album = @artist.albums.new
  end
  #...
```
Add the form to the artists show view
```erb
<% # app/views/artists/show.html.erb %>

<% # ... %>

<%= form_for [@artist, @album] do |f| %>
  <%= f.label :name %>: <%= f.text_field :name %><br>
  <%= f.label :release_year %>: <%= f.text_field :release_year %><br>
<% end %>
<% # ... %>
```
Now add a albums controller with a create action.
```ruby
# app/controllers/albums_controller.rb
class AlbumsController < ApplicationController
  def create
    @artist = Artist.find(params[:artist_id])
    @album = @artist.albums.new(params.require(:album).permit([:name, :release_year]))

    if @album.save
      redirect_to @artist
      flash[:notice] = "Album Saved!"
    else
      redirect_to @artist
      flash[:alert] = "Album not Saved!"
    end
  end
end
```
## [Add Albums Show View Controller Action, and Route](https://github.com/CodeCoreYVR/may_2015_ruby/commit/40851b42bc418289dc25258672962121006dfe3c)
When we added albums, we did so under artists. We used the artist show page and added a form. Since we told the form that we were using a route to the albums controller `form_for [@artist, @album] do |f|` we could have written this `form_for @album, url: artist_albums_path(@album) do |f|` instead, and have gotten the same effect. For more information on the Rails `form_for` method check out the [docs](http://api.rubyonrails.org/classes/ActionView/Helpers/FormHelper.html#method-i-form_for).  
  
So, let's think about an album show view, and a form that allows us to add songs to that album. This is exactly the same as we have just done with adding albums to artists, so let's begin by adding a form for new songs to the album show view (ok, ok, let's start by adding an album show view *and a route*).  
  
This actually brings up an interesting design choice. Do we want a URL in the format of `/albums/album_id/songs/song_id/` or `/artists/artist_id/albums/album_id/songs/song_id`. We usually do not like to have our resources nested very deeply, however we may have reasons of SEO to consider, and may opt for one style over the other. **Note**: We will discuss generating more RESTful URLs later on over the course (e.g. replacing `album_id` with the title of the album, etc.). For now, we'll give albums their own (un-nested resource [route], and nest songs within that).  
```ruby
# config/routes.rb
Rails.applications.routes.draw do
  # ...

  resources :albums, only [:index, :show]

  # ...
end
```
And let's add a show action to the albums controller. We can see in our routes (`http://localhost:3000/rails/info/routes`), that the show path takes an id. It follows that we can find the album based on its id.
```ruby
# app/controllers/albums_controller.rb

class AlbumsController < ApplicationController
  # ...

  def show
    @album = Album.find(params[:id])
  end
  # ...
end
```
So, we have a method `album_path` which takes an album id and will route us to the show view for albums. Let's make a link on the artists show page to the albums show page.
```erb
<% # app/views/artists/show.html.erb %>

  <% @artist.albums.each do |album| %>
    <tr>
      <td><%= album.name %></td>
      <td><%= album.release_year %></td>
      <td><%= link_to "show", album %></td>
    </tr>
  <% end %>
```
And now we need a view to show the album.
```erb
<% # app/views/albums/show.html.erb %>

<h1><%= @album.name %></h1>
```
## [Add Songs Form on Album Show View](https://github.com/CodeCoreYVR/may_2015_ruby/commit/862d59a161a8f1e7f4743f83a83a1ed86a1bbfc3)
Let's add that form to create songs. Remember that songs belong to albums and albums have many songs. This should remind us that we will set up an `album_songs_path`, and can either use it explicitly when we call the `form_for` method or imply it by passing the array `[@album, @song]`.  
  
```erb
<% # app/views/albums/show.html.erb %>

<h1><%= @album.name %></h1>

<h2>Add Song</h2>
<%= form_for [@album, @song] do |f| %>
  <%= f.label :title %>
  <%= f.text_field :title %><br>
  <%= f.label :youtube_link, "video link" %>
  <%= f.text_field :youtube_link %><br>
  <%= f.submit %>
<% end %>
```
We will need to instantiate `@song` in our albums controller (because the show action for this view is in the albums controller).
```ruby
# app/controllers/albums_controller.rb

  # ...

  def show
    @album = Album.find(params[:id])
    @songs = @album.songs
    @song = Song.new
  end

  # ...

```
Let's add the nested resource for creating songs in our routes file
```ruby
# config/routes.rb

Rails.application.routes.draw do

  # ...

  resources :albums, only: [:index, :show] do
    resources :songs, only: [:create, :delete]
  end

  # ...
end
```
Now, when we submit the form, we will want the songs create action to set the album and artist ids, so let's modify the create action. We also probably want to modify the redirects so we only use the albums show view.
```ruby
# app/controllers/songs_controller.rb

  # ...

  def create
    @song = Song.new(params.require(:song).
                     permit([:title, :youtube_link]))
    @song.album_id = params[:album_id]
    @song.artist_id = @song.album.artist_id
    if @song.save
      flash[:notice] = "Saved your song!"
      redirect_to album_path(@song.album_id)
    else
      flash[:alert] = "Something went wrong! Please refresh and try again."
        redirect_to album_path(@song.album_id)
      end
    end
  end

  # ...

```
Let's add a link to the album on the songs index view
```erb
<% # app/views/songs/index.html.erb %>

  <% @songs.each do |song| %>
    <tr>
      <td><%= song.title %></td>
      <td><%= link_to song.album.name, album_path(song.album.id) %></td>
      <td><%= link_to song.album.artist.name, song.album.artist %></td>
      <td><%= link_to "watch", song.youtube_link %></td>
      <td><%= link_to "edit", song_path(song.id) %></td>
    </tr>
  <% end %>
```
And finally, let's add a list of all the songs on the albums show view, and a link to delete songs. This time, rather than using a rails helper method, let's just use the path in the delete link. This will hopefully make it clear where the album id and song id are being passed from.
```erb
<% # app/views/albums/show.html.erb %>

<h1><%= @album.name %></h1>

<h2>Add Song</h2>
<%= form_for [@album, @song] do |f| %>
  <%= f.label :title %>
  <%= f.text_field :title %><br>
  <%= f.label :youtube_link, "video link" %>
  <%= f.text_field :youtube_link %><br>
  <%= f.submit %>
<% end %>

<hr>
<h2>Songs<h2>

<table>
  <tr>
    <th>title</th>
    <th>watch</th>
    <th>edit</th>
  </tr>
  <% @songs.each do |song| %>
    <tr>
      <td><%= song.title %></td>
      <td><%= link_to "watch", song.youtube_link %></td>
      <td><%= link_to "delete", "/albums/#{song.album_id}/songs/#{song.id}", method: :delete %></td>
    <tr>
  <% end %>
</table>
```
## [Add Artists Index View (and remove add song link)](https://github.com/CodeCoreYVR/may_2015_ruby/commit/dbea117d6ada9bd32e5a71f4916d7cad169ac0e9)
Let's add a view to display all the artists. We can add artists, view artist pages where we can add albums, or view albums to add songs. This might not be the best design, but it works for us for now.
```erb
<% # app/views/artists/index.html.erb %>

<h1>All Artists</h1>

<table>
  <tr>
    <th>name</th>
    <th>albums</th>
  </tr>
  <% @artists.each do |artist| %>
    <tr>
      <td><%= artist.name %></td>
      <td><%= link_to "albums", artist_path(artist) %></td>
    </tr>
  <% end %>
</table>
```
Let's also add a route for for artists
```ruby
# config/routes.rb

  # ...

  resources :artists, only: [:new, :create, :show, :index] do
    resources :albums, only: [:create]
  end

  # ...
```
And of course an index action in the artists controller
```ruby
# app/controllers/artists_controller.rb

class ArtistsController < ApplicationController
  def index
    @artists = Artist.all
  end
end
```
And, let's remove the "add song" link from our application layout
```erb
<% # app/views/layouts/application.html.erb %>

  <%= link_to "home", root_path %> |
  <%= link_to "add artist", new_artist_path %>
```
Let's also go ahead and remove the broken edit link on the songs index
page
```erb
<% # app/views/songs/index.html.erb %>

  <% @songs.each do |song| %>
    <tr>
      <td><%= song.title %></td>
      <td><%= link_to song.album.name, album_path(song.album.id) %></td>
      <td><%= link_to song.album.artist.name, song.album.artist %></td>
      <td><%= link_to "watch", song.youtube_link %></td>
    </tr>
  <% end %>
```
## [Dependent Destroy](https://github.com/CodeCoreYVR/may_2015_ruby/commit/e44ca63e33bf6be1f45172e50b3075b38a4e1a33)
Now, we will notice that if we remove artists, or albums, we will have orphaned albums or songs. In order to avoid this, we'll add [dependent: :destroy](http://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html#module-ActiveRecord::Associations::ClassMethods-label-Deleting+from+associations) to our `has_many` associations.
```ruby
# app/models/album.rb

class Artist < ActiveRecord::Base
  has_many :albums, dependent: :destroy
end
```
```ruby
# app/models
class Album < ActiveRecord::Base
  belongs_to :artist
  has_many :songs, dependent: :destroy
end
```
## [Bug Fix](https://github.com/CodeCoreYVR/may_2015_ruby/commit/d72ee959a054e92f7dc66ecd2cbc20602e79f846)
You may notice that our artists show view has an additional album displaying. This is because we have a form for creating a new album that has `@album` instantiated as `@artist.albums.new`. That means, when we iterate through `@artist.albums` we also have this empty (new) album.  
  
We can deal with this in a couple of ways. For example, we could instantiate a collection of artist albums `@albums = @artist.albums.all` and then instantiate the new album, or we could instantiate the new album as `@album = Album.new`. This time, let's try the latter.
```ruby
# app/controllers/artists_controller.rb

# ...
  def show
    @artist = Artist.find(params[:id])
    @album = Album.new
  end
# ...
```
## [Add Seed Data](https://github.com/CodeCoreYVR/may_2015_ruby/commit/91859b5be272c913fe42a249016385253c4c290a)
Let's add some seed data to our database. We'll add some artists and albums, then just add songs in manually.
```ruby
# db/seed.rb

groups = {"faded paper figures" => {"dynamo" => "2008", "new medium" => "2010", "the Matter" => "2012", "relics" => "2014"},
          "pomegranates" => {"everything is alive" => "2008", "everybody come outside" => "2009", "one of us" => "2010", "heaven (modern outsider)" => "2012"},
          "summer heart" => {"never let me go" => "2011", "about a feeling" => "2012"},
          "white rabbits" => {"fort nightly" => "2007", "it's frightening" => "2009", "milk famous" => "2012"},
          "mystery jets" => {"making dens" => "2005", "zootime" => "2007", "twenty one" => "2008", "serotonin" => "2010", "radlands" => "2012"}}


groups.each do |name, albums|
  artist = Artist.create(name: name)
  albums.each do |title, release_year|
    artist.albums.create(name: title, release_year: release_year, artist_id: artist.id)
  end
end
```
In the terminal run `bin/rake db:seed` to populate your database with seed data.
## [Add a Nav Link to All Artists](https://github.com/CodeCoreYVR/may_2015_ruby/commit/5c9add150ed2d27f0fffe7330577319f49a43748)
Simply open up the application layout and add a link
```erb
<% # app/views/layouts/application.html.erb %>

<% # ... %>

  <%= link_to "home", root_path %> |
  <%= link_to "all artists", artists_path %> |
  <%= link_to "add artist", new_artist_path %>

<% # ... %>
```
## Add Users and User Auth
Let's add users to our app, and a way for them to sign in. We can start by generating a user model. We can decide what attributes we want our users to have now, or we can add them later. We can always change our mind, so we don't have to feel that anything is set in stone. Let's add users with first names, last names, and email addresses, and passwords.  
  
We are going to user [`has_secure_password`](http://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html#method-i-has_secure_password), which adds methods and authenticates against a BCrypt password. This *requires* us to have a `password_digest` attribute.
  
Generate a user model
```shell
bin/rails generate model user first_name:string last_name:string email:string password_digest:string
```
Before migrating, we can optionally add an index to our the email field. While we're at it, we can also add a requirement for user emails to be unique. Why not, right?
```ruby
# db/migrate/20150620191026_create_users.rb

class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
  end
end
```
Go ahead and `bin/rake db:migrate` then open up the user model where we can add validation for the user email. If you Google [rails email validation regex](https://www.google.ca/search?q=rails+email+validation+regex&oq=rails+email+validation+regex&aqs=chrome..69i57.4255j0j4&sourceid=chrome&es_sm=119&ie=UTF-8), you'll find many alternatives. Choose one that works for you.  
  
If you are completely unfamiliar with regex, you will no doubt find this [incredibly brief guide](http://archive.oreilly.com/pub/a/ruby/excerpts/ruby-learning-rails/ruby-guide-regular-expressions.html) helpful.
```ruby
# app/models/user.rb

class User < ActiveRecord::Base
  has_secure_password
  validates :email, presence: true, uniqueness: true,
            format:  /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
end
```
Add some routes for new and create actions
```ruby
# config/routes.rb

Rails.application.routes.draw do
  root "songs#index"

  get "/songs" => "songs#new"
  post "/songs" => "songs#create"

  get "/songs/:id" => "songs#edit", as: :song
  patch "/songs/:id" => "songs#update"

  resources :artists, only: [:new, :create, :show, :index] do
    resources :albums, only: [:create]
  end

  resources :albums, only: [:index, :show] do
    resources :songs, only: [:create, :destroy]
  end

  resources :users, only: [:new, :create]

end
```
Now that we have our route, let's add a users controller with the new and create actions. *Note* that we are adding `session[:user_id] = @user.id` after creation to authenticate the user to our website on create.
```ruby
# app/controllers/users_controller.rb

class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(params.require(:user).
              permit([:first_name, :last_name, :email, :password,
                      :password_confirmation])
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Logged in!"
    else
      render :new
    end
  end
end
```
Add a view to display a form to create new users
```erb
<% # app/views/users/new.html.erb %>

<h1>Sign Up</h1>

<% if @user.errors.any? %>
  <ul>
    <% @user.errors.full_messages.each do |msg| %>
      <li><%= msg %></li>
    <% end %>
  </ul>
<% end %>

<%= form_for @user do |f| %>
  <div>
    <%= f.label :first_name %>
    <%= f.text_field :first_name %>
  </div>
  <div>
    <%= f.label :last_name %>
    <%= f.text_field :last_name %>
  </div>
  <div>
    <%= f.label :email %>
    <%= f.email_field :email %>
  </div>
  <div>
    <%= f.label :password %>
    <%= f.password_field :password %>
  </div>
  <div>
    <%= f.label :password_confirmation %>
    <%= f.password_field :password_confirmation %>
  </div>
  <%= f.submit %>
<% end %>
```
## Add Sessions Controller
We are going to use the `@user.athenticate` method, which came with the `has_secure_password` method. This method hashes the user's password and compares it to the password digest. If the hash is the same, then the password entered must have been the same, and the method returns `true`. Otherwise, it will return `false`. *Aside*: [hashing, encryption, encoding](https://danielmiessler.com/study/encoding_encryption_hashing/) are interesting topics worth spending some time to read up on.  
  
If the user is authenticated, then we can create a session.
```ruby
class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by_email params[:email]
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Logged in"
    else
      flash[:alert] = "Unknown email or password"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out"
  end
end
```
Since there isn't a session model, we will use a `form_tag` for the session, not `form_for` for the sessions new view
```erb
<% # app/views/sessions/new.html.erb %>

<h1>Sign In</h1>

<%= form_tag sessions_path do %>
  <div>
    <%= label_tag :email %>
    <%= email_field_tag :email %>
  </div>
  <div>
    <%= label_tag :password %>
    <%= password_field_tag :password %>
  </div>
  <div>
    <%= submit_tag "Log In" %>
  </div>
<% end %>
```
And of course, make sure to add resources for sessions new, create, and destroy on collection
```ruby

```ruby
# config/routes.rb

Rails.application.routes.draw do
  root "songs#index"

  get "/songs" => "songs#new"
  post "/songs" => "songs#create"

  get "/songs/:id" => "songs#edit", as: :song
  patch "/songs/:id" => "songs#update"

  resources :artists, only: [:new, :create, :show, :index] do
    resources :albums, only: [:create]
  end

  resources :albums, only: [:index, :show] do
    resources :songs, only: [:create, :destroy]
  end

  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create] do
    delete :destroy, on: :collection
  end

end
```
We have the line `delete :destroy, on: :collection` this makes the route without id or user id in it.  
  
Let's also add some useful methods for our users in our application controller. Since we will want to check for a current user on several of the views, let's add a `current_user` method, a `user_signed_in?` method, and a `current_user` method. Since we want the latter two to be available to the views, we will declare them [`helper_method`](http://apidock.com/rails/ActionController/Helpers/ClassMethods/helper_method)s.
```erb
# app/controllers/application_controller.rb

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate_user!
    redirect_to new_session_path, notice: "Please login" unless user_signed_in?
  end

  def user_signed_in?
    current_user.present?
  end
  helper_method :user_signed_in?

  def current_user
    @current_user ||= User.find_by_id session[:user_id]
  end
  helper_method :current_user
end
```
Let's use the `authenticate_user!` method in our artists and albums controllers so we only allow registered users to add albums.
```ruby
# app/controllers/artists_controller.rb

class ArtistsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  def index
    @artists = Artist.all
  end

  def new
    @artist = Artist.new
  end

  def create
    @artist = Artist.new(params.require(:artist).permit([:name]))

    if @artist.save
      flash[:notice] = "Artist saved!"
      redirect_to artist_path(@artist.id)
    else
      render :new
      flash[:alert] = "Artist not saved!"
    end
  end

  def show
    @artist = Artist.find(params[:id])
    @album = Album.new
  end
end
```
```ruby
# app/controllers/albums_controller.rb

class AlbumsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  def create
    @artist = Artist.find(params[:artist_id])
    @album = @artist.albums.new(params.require(:album).permit([:name, :release_year]))

    if @album.save
      redirect_to @artist
      flash[:notice] = "Album Saved!"
    else
      redirect_to @artist
      flash[:alert] = "Album not Saved!"
    end
  end

  def show
    @album = Album.find(params[:id])
    @songs = @album.songs
    @song = Song.new
  end
end
```
And, finally let's add some links to our navigation to display differently with signed in users and not.
```erb
<% # app/views/layouts/application.html.erb %>

<!DOCTYPE html>
<html>
<head>
  <title>Review</title>
  <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track' => true %>
  <%= javascript_include_tag 'application', 'data-turbolinks-track' => true %>
  <%= csrf_meta_tags %>
</head>
<body>
  <%= link_to "home", root_path %> |
  <%= link_to "all artists", artists_path %> |
  <%= link_to "add artist", new_artist_path %> |
  <% if user_signed_in? %>
  <%= link_to "logout #{current_user.email}", sessions_path, method: :delete,
                 data: {confirm: "log out?"} %>
  <% else %>
  <%= link_to "login", new_session_path %> |
  <%= link_to "sign up", new_user_path %> 
  <% end %>
  <%= yield %>

</body>
</html>
```
## Many to Many: Add Likes (Users Like Songs)
With a many to many relationship, we'll be using a join-table. Our join table simply contains id references for two models. In this case, we are going to have users and songs be _joined_ with likes.  
  
Our like entries will have `user_id` and `song_id` fields, and will look something like this
id | user_id | song_id | created_at | updated_at
-- | ------- | ------- | ---------- | ----------
1  | 4       | 2       | 2015-06-20 23:27:55 UTC | 2015-06-20 23:27:55 UTC
  

Let's start with the like model
```shell
bin/rails generate model like user:references song:references
```
This creates a migration for us
```ruby
# db/migrate/20150621032912_create_likes.rb
class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.references :user, index: true, foreign_key: true
      t.references :song, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
```
Let's add some associations to our like, user, and song models
```ruby
# app/models/like.rb
class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :song
end
```
```ruby
# app/models/user.rb

class User < ActiveRecord::Base
  has_secure_password
  validates :email, presence: true, uniqueness: true,
            format:  /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  has_many :likes, dependent: :destroy
  has_many :songs, through: :likes
end
```
```ruby
# app/models/song.rb

class Song < ActiveRecord::Base
  belongs_to :album
  scope :recent_five, -> { order("updated_at DESC").limit(5) }
  has_many :likes, dependent: :destroy
  has_many :users, through: :likes
end
```
Add a routes for song likes for create and destroy actions
```ruby
# config/routes.rb

Rails.application.routes.draw do
  root "songs#index"

  get "/songs" => "songs#new"
  post "/songs" => "songs#create"

  get "/songs/:id" => "songs#edit", as: :song
  patch "/songs/:id" => "songs#update"

  resources :artists, only: [:new, :create, :show, :index] do
    resources :albums, only: [:create]
  end

  resources :albums, only: [:index, :show] do
    resources :songs, only: [:create, :destroy]
  end

  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create] do
    delete :destroy, on: :collection
  end

  resources :songs do
    resources :likes, only: [:create, :destroy]
  end

end
```
Add a likes controller with create and destroy actions
```ruby
app/controllers/likes_controller.rb

class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    like = current_user.likes.new
    song = Song.find(params[:song_id])
    like.song = song
    if like.save
      redirect_to song, notice: "liked"
    else
      redirect_to song, alert: "not liked"
    end
  end

  def destroy
    like = current_user.likes.find(params[:id])
    like.destroy
    redirect_to song, notice: "unliked"
  end
end
```

Instantiate a like in the albums controller show action
```ruby
# app/controllers/albums_controller.rb

class AlbumsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  def create
    @artist = Artist.find(params[:artist_id])
    @album = @artist.albums.new(params.require(:album).permit([:name, :release_year]))

    if @album.save
      redirect_to @artist
      flash[:notice] = "Album Saved!"
    else
      redirect_to @artist
      flash[:alert] = "Album not Saved!"
    end
  end

  def show
    @album = Album.find(params[:id])
    @songs = @album.songs
    @song = Song.new
    @like = @song.likes.new

  end
end
```
Also instantiate a like in the songs controller index action
```ruby
# app/controllers/songs_controller.rb

  # ...

  def index
    @songs = Song.recent_five
    @like = Like.new
  end

  # ...
```
For each of the songs we display on the index view, we want to see if there is a like for the current user. Let's add a method to the song model to check for likes that have a `user_id` matching the current user.
```ruby
# app/models/song.rb

  # ...

    def like_for(user)
      self.likes.find_by_user_id(user)
    end

  # ...

```
This method takes a user, and returns a like if one exists with that user's id. Note that _self_ refers to the song we pass in, so we can call `@song.like_for(current_user)` and it will return the like if it exists.  
  
When we iterate through the songs on the songs index page, we can see if there are any likes. If not, we'll have a link to like a song, otherwise, we'll have a link to delete the like.
```erb
<% # app/views/songs/index.html.erb %>

 <% # ... %>

  <% @songs.each do |song| %>
    <tr>
      <td><%= song.title %></td>
      <td><%= link_to song.album.name, album_path(song.album.id) %></td>
      <td><%= link_to song.album.artist.name, song.album.artist %></td>
      <td><%= link_to "watch", song.youtube_link %></td>
      <% if song.like_for(current_user) %>
        <td><%= link_to "unlike", song_like_path(song, song.like_for(current_user)), method: :delete %></td>
      <% else %>
        <td><%= link_to "like", song_likes_path(song), method: :post %></td>
      <% end %>
    </tr>
  <% end %>

  <% # ... %>

```
We now have the ability to like on the root page. Remember this is our songs index, and is being fed the most recent five songs by the index controller. But what about when we view album show pages. There are also lists of songs. Let's add likes to the album show pages.
```erb
<% # app/views/albums/show.html.erb %>

  <% # ... %>

  <% @songs.each do |song| %>
    <tr>
      <td><%= song.title %></td>
      <td><%= link_to "watch", song.youtube_link %></td>
      <td><%= link_to "delete", "/albums/#{song.album_id}/songs/#{song.id}", method: :delete %></td>
      <% if song.like_for(current_user) %>
        <td><%= link_to "unlike", song_like_path(song, song.like_for(current_user)), method: :delete %></td>
      <% else %>
        <td><%= link_to "like", song_likes_path(song), method: :post %></td>
      <% end %>
    </tr>
  <% end %>

  <% # ... %>

```
This allows us to add likes, but our likes create action is redirecting us back to the root path. If we want to redirect back to where we are, i.e. redirect back to the index view _if we were on the index view_ and redirect back to the albums show view, _if we were on the albums show view_ when we clicked like or unlike, we can use `redirect_to :back`. Let's change this in our likes create action (and also in our delete action).
```ruby
# app/controllers/likes_controller.rb

class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    like = current_user.likes.new
    song = Song.find(params[:song_id])
    like.song = song
    if like.save
      redirect_to :back, notice: "liked"
    else
      redirect_to :back, alert: "not liked"
    end
  end

  def destroy
    like = current_user.likes.find(params[:id])
    like.destroy
    redirect_to :back, notice: "unliked"
  end
end
```
