class ArtistsController < ApplicationController
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
    @album = @artist.albums.new
  end
end
