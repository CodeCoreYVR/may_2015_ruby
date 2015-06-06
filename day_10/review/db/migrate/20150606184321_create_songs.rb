class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :title
      t.string :artist
      t.string :album
      t.string :youtube_link

      t.timestamps null: false
    end
  end
end
