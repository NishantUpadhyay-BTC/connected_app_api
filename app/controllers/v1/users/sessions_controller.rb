module V1
  class Users::SessionsController < Devise::SessionsController
    respond_to :json

    # POST /resource/sign_in
    def create
      self.resource = warden.authenticate!(auth_options)
      set_flash_message(:notice, :signed_in) if is_flashing_format?
      sign_in(resource_name, resource)
      respond_to do |format|
        format.json { render json: { data: { user: self.resource }}, status: 200 }
      end
    end
  end
end
