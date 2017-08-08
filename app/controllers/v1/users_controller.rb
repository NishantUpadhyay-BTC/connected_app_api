module V1
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: [:near_by_users,:update_location]

    def show
      user = User.find(params[:id])
      profile = user.profile
      render json: {
        profile: profile
      }
    end

    # GET /users/:id/near_by_users
    def near_by_users
      begin
        results = @user.near_by_me(params)
        respond_to do |format|
          format.json { render json: { data: { user: results }}, status: 200 }
        end
      rescue TypeError => e
        respond_to do |format|
          format.json { render json: { data: { error: e }}, status: 422 }
        end
      end

    end

    # PUT /users/:id/update_location
    def update_location
      response = @user.profile.update_attributes(:latitude => params[:latitude].to_f,:longitude => params[:longitude].to_f) if @user.profile

      respond_to do |format|
        if response == true
          format.json { render json: { data: { response: response }}, status: 200 }
        else
          format.json { render json: { data: { response: response }}, status: 422 }
        end
      end
    end

    def edit
    end

    def update
    end

    private

    def set_user
      @user = User.find(params[:id]) if params[:id]
    end
  end
end
