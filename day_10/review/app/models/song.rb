class Song < ActiveRecord::Base
  belongs_to :album
  scope :recent_five, -> { order("updated_at DESC").limit(5) }
end
