module V1
  class UsersController < ApplicationController
    before_action :authenticate_user!

    def show
      user = User.find(params[:id])
      profile = user.profile
      render json: {
        profile: profile
      }
    end

    def edit
    end

    def update
    end

    def favorite
      other_user = User.find params[:id]
      message = ''
      if current_user.present?
        if current_user.favorited?(other_user)
          current_user.unfavorite(other_user)
          message = 'User removed from your favorites list.'
        else
          current_user.favorite(other_user)
          message = 'User added to your favorites list.'
        end
      end
      render json: { message: message }
    end

    def favorites_list
      favorited_users = current_user.favorites
      favorited_users_data = {}

      favorited_users.each_with_index do |user, index|
        favorited_users_data[user.id] = {}
          if user.profile.present?
            favorited_users_data[user.id][:name] = "#{user.profile.first_name} #{user.profile.last_name}"
            favorited_users_data[user.id][:favorited_at] = Relationship.where(follower_id: current_user.id, followed_id: user.id).first.created_at
          end
      end
      render json: {favorited_users: favorited_users_data}
    end
  end
end
