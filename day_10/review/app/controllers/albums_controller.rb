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

  def show
    @album = Album.find(params[:id])
  end
end
