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

    private

    def profile_params
      params.require(:profile).permit(:first_name, :last_name, :phone_number,
        :facebook_url, :snapchat_url, :instagram_url, :birth_date,
        :display_phone_number, :display_facebook, :display_snapchat,
        :display_instagram, :display_age, :display_profile)
    end

    private

    def set_user
      @user = User.find(params[:id]) if params[:id]
    end

    private

    def set_user
      @user = User.find(params[:id]) if params[:id]
    end
  end
end
