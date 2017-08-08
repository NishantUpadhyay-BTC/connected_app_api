class AddLatitudeAndLongitudeToProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :profiles, :latitude, :float
    add_index :profiles, :latitude
    add_column :profiles, :longitude, :float
    add_index :profiles, :longitude
  end
end
