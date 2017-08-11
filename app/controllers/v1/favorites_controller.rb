# frozen_string_literal: true

module V1
  class FavoritesController < ApplicationController
    before_action :authenticate
    before_action :assign_other_user, only: %i[create destroy]

    def index
      favorited_users = current_user.favorites.zip(current_user.active_relationships)
      user_favorites = []
      favorited_users.each do |user, relationship|
        user_favorites << {
          user_id: user.id,
          name: user.username,
          favorited_at: relationship.created_at
        }
      end
      render json: { favorited_users: user_favorites }
    end

    def create
      if current_user.favorite(@other_user)
        message = t('favorite.add')
      else
        message = t('favorite.unable_to_add')
      end
      render json: { message: message }
    end

    def destroy
      if current_user.favorited?(@other_user)
        if current_user.unfavorite(@other_user)
          message = t('favorite.remove')
        else
          message = t('favorite.unable_to_remove')
        end
      else
        message = t('favorite.not_favorited')
      end
      render json: { message: message }
    end

    private

    def assign_other_user
      @other_user = User.find params[:id]
      render json: { message: t('user.not_found') } and return unless @other_user.present?
    end
  end
end
