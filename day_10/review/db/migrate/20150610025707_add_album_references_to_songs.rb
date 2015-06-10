class AddAlbumReferencesToSongs < ActiveRecord::Migration
  def change
    add_reference :songs, :album, index: true, foreign_key: true
  end
end
