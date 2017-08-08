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

  has_many :favorites, through: :active_relationships, source: :followed
  # has_many :followers, through: :passive_relationships, source: :follower

  # TEMP METHOD FOR FB TOKEN MANAGEMENT
  def self.from_payload(params)
    where(fb_token: params[:token]).first_or_create do |user|
      user.fb_token = params[:token]
    end
  end


  def near_by_me(params)
    point = point(params)
    unit = params[:unit].to_sym if params[:unit]
    distance = params[:distance].to_f if params[:distance]
    users_within_location =
                Profile.near(point, distance, :units => unit,:order => '')
                .reject{|profile| profile.user_id == id }
  end

  def point(params)
    [params[:latitude].to_f,params[:longitude].to_f]
  end

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
