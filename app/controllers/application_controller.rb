require 'json_web_token'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :set_locale

  def set_locale
    return I18n.default_locale if current_user.blank? || current_user.profile.blank?
    I18n.locale = current_user.profile.locale.to_sym
  end
end
