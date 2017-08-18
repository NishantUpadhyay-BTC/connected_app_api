class Profile < ApplicationRecord
  belongs_to :user

  geocoded_by latitude: :latitude, longitude: :longitude

  def basic_details
    {
      user_id: user.id,
      first_name: first_name,
      last_name: last_name,
      latitude: latitude,
      longitude: longitude,
      avatar: avatar,
      visibility: 1
    }
  end
end
