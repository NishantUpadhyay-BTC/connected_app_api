class AddLocaleToProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :profiles, :locale, :string, default: 'en'
  end
end
