class SongsController < ApplicationController
  def index
    @songs = Song.recent_five
  end

  def new
    @song = Song.new
  end

  def create
    @song = Song.new(params.require(:song).
                     permit([:title, :artist, :album, :youtube_link]))
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
end
