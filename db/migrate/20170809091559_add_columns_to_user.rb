class AddColumnsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :provider, :string
    add_column :users, :token, :string
    add_column :users, :platform, :string
    add_column :users, :device_id, :string
  end
end
