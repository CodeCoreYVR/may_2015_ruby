class SongsController < ApplicationController
  def index
    @songs = Song.recent_five
    @like = Like.new
  end

  def new
    @song = Song.new
  end

  def create
    @song = Song.new(params.require(:song).
                     permit([:title, :youtube_link]))
    @song.album_id = params[:album_id]
    @song.artist_id = @song.album.artist_id
    if @song.save
      flash[:notice] = "Saved your song!"
      redirect_to root_path
    else
      flash[:alert] = "Something went wrong! Please refresh and try again."
      render :new
    end
  end

  def edit
    @song = Song.find(params[:id])
  end

  def update
    @song = Song.find(params[:id])

    if @song.update(params.require(:song).
        permit([:title, :artist, :album, :youtube_link]))
      flash[:notice] = "Song updated successfully."
      redirect_to root_path
    else
      flash[:alert] = "Unable to update song. Please try again."
      render :edit
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @album = @song.album
    if @song.delete
      redirect_to @album
      flash[:notice] = "Song deleted!"
    else
      redirect_to @album
      flash[:alert] = "Song not deleted!"
    end
  end
end
