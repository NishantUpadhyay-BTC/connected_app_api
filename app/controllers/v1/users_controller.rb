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
  end
end
