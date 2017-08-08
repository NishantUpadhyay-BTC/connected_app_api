class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JWTBlacklist

  has_one :profile, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy

  has_many :favorites, through: :active_relationships, source: :followed,
    dependent: :destroy
  # has_many :followers, through: :passive_relationships, source: :follower

  # Follows a user.
  def favorite(other_user)
    favorites << other_user
  end

  # Unfollows a user.
  def unfavorite(other_user)
    favorites.delete(other_user)
  end

  # Returns true if the current user is following the other user.
  def favorited?(other_user)
    favorites.pluck(:email).include?(other_user.email)
  end

  def username
    if profile.present?
      "#{profile.first_name} #{profile.last_name}"
    else
      self.email
    end
  end
end
