# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JWTBlacklist

  devise :omniauthable, omniauth_providers: [:facebook]
  has_one :profile, dependent: :destroy
  has_many :active_relationships, class_name:  'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent:   :destroy
  has_many :favorites, through: :active_relationships, source: :followed
  validates_uniqueness_of :uid
  validates_presence_of   :email, if: :email_required?
  validates_uniqueness_of :email, allow_blank: true, if: :email_changed?
  validates_uniqueness_of :email, allow_blank: true

  def self.from_omniauth(auth_details)
    where(provider: auth_details[:provider],
          uid: auth_details[:uid]).first_or_create do |user|
      user.email = auth_details[:email]
      user.password = Devise.friendly_token[0, 20]
      user.platform = auth_details[:platform]
      user.device_id = auth_details[:device_id]
      user.profile = Profile.new(first_name: auth_details[:first_name], last_name: auth_details[:last_name])
      user.save
    end
  end

  def near_by_me(params)
    # unit = params[:unit].to_sym if params[:unit]
    unit = :km
    distance = params[:location_details][:distance].to_f if params[:location_details][:distance]
    user_profiles_within_location =
                Profile.near(point(params[:location_details]), distance, units: unit, order: '')
                       .reject{ |profile| profile.user_id == id }
    profiles = []
    user_profiles_within_location.each do |profile|
      profiles << profile.basic_details
    end
    profiles
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

  protected

  def email_required?
    false
  end

  def email_changed?
    false
  end

  private

  def point(location_details)
    [location_details[:latitude].to_f, location_details[:longitude].to_f]
  end
end
