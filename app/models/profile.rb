class Profile < ApplicationRecord
  belongs_to :user

  geocoded_by latitude: :latitude, longitude: :longitude
  mount_uploader :avatar, AvatarUploader

  def basic_details
    {
      user_id: user.id,
      first_name: first_name,
      last_name: last_name,
      latitude: latitude,
      longitude: longitude,
      avatar_url: '',
      visibility: 1
    }
  end
end
