class RemoveColumnReleaseYearFromAlbum < ActiveRecord::Migration
  def change
    remove_column :albums, :release_year, :datetime
    add_column :albums, :release_year, :string
  end
end
