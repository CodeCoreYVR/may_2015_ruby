class Song < ActiveRecord::Base
  belongs_to :album
  scope :recent_five, -> { order("updated_at DESC").limit(5) }
  has_many :likes, dependent: :destroy
  has_many :users, through: :likes

  def like_for(user)
    self.likes.find_by_user_id(user)
  end
end
