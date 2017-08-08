class Profile < ApplicationRecord
  belongs_to :user

  geocoded_by latitude: :latitude, longitude: :longitude
  mount_uploader :avatar, AvatarUploader
end
