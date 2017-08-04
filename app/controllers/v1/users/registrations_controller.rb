module V1
  class Users::RegistrationsController < Devise::RegistrationsController
    respond_to :json

    # POST /users
    def create
      build_resource(sign_up_params)
      resource.save
      yield resource if block_given?
      if resource.persisted?
        if resource.active_for_authentication?
          set_flash_message :notice, :signed_up if is_flashing_format?
          msg = find_message(:signed_up, {})
          sign_up(resource_name, resource)
          resource.profile = Profile.new(profile_params)
          respond_to do |format|
            format.json { render json: { data: { user: resource} }, status: 200 }
          end
        else
          set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
          msg = find_message(:"signed_up_but_#{resource.inactive_message}", {})
          expire_data_after_sign_in!
          respond_with(resource) do |format|
            format.json { render json: {message: msg }, status: 200 }
          end
        end
      else
        clean_up_passwords resource
        respond_to do |format|
          format.json { render json: {data: { message: resource.errors.full_messages }}, status: 401 }
        end
      end
    end

    private

    def profile_params
      params.require(:profile).permit(:phone_number,
                                      :facebook_url,
                                      :snapchat_url,
                                      :instagram_url,
                                      :birth_date,
                                      :display_phone_number,
                                      :display_facebook,
                                      :display_snapchat,
                                      :display_instagram,
                                      :display_age,
                                      :display_profile)
    end
  end
end
