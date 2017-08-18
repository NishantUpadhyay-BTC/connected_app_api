class AddFieldsToProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :profiles, :recent_location1, :string
    add_column :profiles, :recent_location2, :string
  end
end
