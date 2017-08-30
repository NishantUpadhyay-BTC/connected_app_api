module V1
  class UsersController < ApplicationController
    before_action :authenticate, except: %i[terms_of_use data_protection]
    before_action :set_user, only: %i[near_by_users update_location show]

    def show
      profile_details = @user.profile.as_json
      profile_details["favorited"] = current_user.favorited?(@user)
      render json: { profile: profile_details }
    end

    # GET /users/:id/near_by_users
    def near_by_users
      results = @user.near_by_me(params)
      respond_to do |format|
        format.json { render json: { data: { profiles: results } }, status: 200 }
      end
    rescue TypeError => e
      respond_to do |format|
        format.json { render json: { data: { error: e } }, status: 422 }
      end
    end

    # PUT /users/:id/update_location
    def update_location
      response = @user.profile.update_attributes(latitude: params[:location_details][:latitude].to_f, longitude: params[:location_details][:longitude].to_f) if @user.profile
      respond_to do |format|
        format.json { render json: { data: { updated: response } } }
      end
    end

    def edit; end

    def update
      message = if current_user.profile.present? && current_user.profile.update_attributes(profile_params)
                  t('user.update')
                else
                  t('user.unable_to_update')
                end
      render json: {
        user: current_user,
        profile: current_user.profile,
        message: message
      }
    end

    def destroy
      message = if current_user.destroy
                  t('user.delete')
                else
                  t('user.unable_to_delete')
                end
      render json: { message: message }
    end

    def terms_of_use; end

    def data_protection; end

    private

    def set_user
      @user = User.find(params[:id]) if params[:id]
    end

    def profile_params
      params.require(:profile).permit(:first_name,
                                      :last_name,
                                      :phone_number,
                                      :facebook_url,
                                      :snapchat_url,
                                      :instagram_url,
                                      :birth_date,
                                      :display_phone_number,
                                      :display_facebook,
                                      :display_snapchat,
                                      :display_instagram,
                                      :display_age,
                                      :display_profile,
                                      :locale,
                                      :avatar,
                                      :latitude,
                                      :longitude,
                                      :recent_location1,
                                      :recent_location2)
    end
  end
end
