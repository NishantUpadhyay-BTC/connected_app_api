module V1
  class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def facebook
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      @user = User.from_omniauth(user_params)

      if @user.persisted?
        sign_in(:user, @user)
        auth_token = JsonWebToken.encode({user_id: @user.id})
        response.headers['Authorization'] = "Bearer #{auth_token}"
        respond_to do |format|
          format.json { render json: { data: { user: @user } }, status: 200 }
        end
      else
        session["devise.facebook_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    end

    def failure
      redirect_to root_path
    end

    private

    def user_params
      params.require(:user).permit(:provider, :device_id, :email, :first_name, :last_name, :uid, :platform)
    end
  end
end
