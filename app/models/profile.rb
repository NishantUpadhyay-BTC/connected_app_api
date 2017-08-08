class Profile < ApplicationRecord
  belongs_to :user

  geocoded_by :latitude  => :latitude, :longitude => :longitude
end
