module V1
  class UsersController < ApplicationController
    before_action :authenticate_user!, except: %i[terms_of_use data_protection create]
    before_action :set_user, only: [:near_by_users,:update_location]

    def show
      user = User.find(params[:id])
      profile = user.profile
      render json: {
        profile: profile
      }
    end

    def create
      @user = User.from_payload(params)

      if @user.persisted? && !@user.profile
        @user.profile = Profile.create!(profile_params)
        response.headers["Authorization"] = @user.auth_token
      end
      respond_to do |format|
        format.json { render json: { data: { user: @user }}, status: 200 }
      end
    end

    # GET /users/:id/near_by_users
    def near_by_users
      begin
        results = @user.near_by_me(params)
        respond_to do |format|
          format.json { render json: { data: { profiles: results }}, status: 200 }
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
          format.json { render json: { data: { updated: response }}, status: 200 }
        else
          format.json { render json: { data: { updated: response }}, status: 422 }
        end
      end
    end

    def edit
    end

    def update
      message = ''
      if current_user.profile.present? && current_user.profile.update_attributes(profile_params)
        message = 'User updated successfully.'
      else
        message = 'not updated'
      end
      render json: {
        user: current_user,
        profile: current_user.profile,
        message: message
      }
    end

    def destroy
      message = ''
      if current_user.destroy
        message = 'User deleted successfully.'
      else
        message = 'Unable to delete user'
      end
      render json: { message: message }
    end

    def terms_of_use
    end

    def data_protection
    end

    private

    def profile_params
      params.require(:profile).permit(:first_name, :last_name, :phone_number,
        :facebook_url, :snapchat_url, :instagram_url, :birth_date,
        :display_phone_number, :display_facebook, :display_snapchat,
        :display_instagram, :display_age, :display_profile)
    end

    def set_user
      @user = User.find(params[:id]) if params[:id]
    end
  end
end
