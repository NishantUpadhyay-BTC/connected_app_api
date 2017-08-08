class ChangeDefaultColumnsInProfile < ActiveRecord::Migration[5.1]
  def change
    change_column_default :profiles, :display_phone_number, true
    change_column_default :profiles, :display_facebook, true
    change_column_default :profiles, :display_snapchat, true
    change_column_default :profiles, :display_instagram, true
    change_column_default :profiles, :display_age, true
    change_column_default :profiles, :display_profile, true
  end
end
