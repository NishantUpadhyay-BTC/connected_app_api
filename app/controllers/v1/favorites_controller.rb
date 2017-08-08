module V1
  class FavoritesController < ApplicationController
    before_action :authenticate_user!
    before_action :assign_other_user, only: [:create, :destroy]

    def index
      favorited_users = current_user.favorites.zip(current_user.active_relationships)
      user_favorites = []
      favorited_users.each do |user, relationship|
        user_favorites << {
          user.id => {
              name: user.username,
              favorited_at: relationship.created_at
            }
          }
      end
      render json: {favorited_users: user_favorites}
    end

    def create
      if current_user.favorite(@other_user)
        message = 'User added to your favorites list.'
      else
        message = 'Unable to favorite this user.'
      end
      render json: { message: message }
    end

    def destroy
      message = ''
      if current_user.favorited?(@other_user)
        if current_user.unfavorite(@other_user)
          message = 'User is removed from favorite list.'
        else
          message = 'Unable to remove user from favorite list.'
        end
      else
        message = 'User is not favorited.'
      end
      render json: { message: message }
    end

    private

    def assign_other_user
      @other_user = User.find params[:id]
      render json: { message: 'No user found' } and return unless @other_user.present?
    end
  end
end
