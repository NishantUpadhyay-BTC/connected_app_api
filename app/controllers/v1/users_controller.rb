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
  end
end
