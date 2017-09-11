class ChangeIndexsToUsers < ActiveRecord::Migration[5.1]
  def change
    remove_index :users, name: "index_users_on_email"
    add_index :users, :uid, name: 'index_users_on_uid'
  end
end
