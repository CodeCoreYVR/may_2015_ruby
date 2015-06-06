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
      flash[:notice] = "Saved your song!"
      redirect_to root_path
    else
      flash[:alert] = "Something went wrong! Please refresh and try again."
      render :new
    end
  end
end