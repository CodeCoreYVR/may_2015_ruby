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
