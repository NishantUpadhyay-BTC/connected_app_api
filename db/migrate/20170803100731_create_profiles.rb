class CreateProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :profiles do |t|
      t.string :phone_number
      t.string :facebook_url
      t.string :snapchat_url
      t.string :instagram_url
      t.date :birth_date
      t.boolean :display_phone_number
      t.boolean :display_facebook
      t.boolean :display_snapchat
      t.boolean :display_instagram
      t.boolean :display_age
      t.boolean :display_profile
      t.integer :user_id
      t.timestamps
    end
  end
end
