class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JWTBlacklist

  has_one :profile,dependent: :destroy


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
end
