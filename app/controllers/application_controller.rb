# frozen_string_literal: true

require 'json_web_token'
class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :set_locale

  def set_locale
    return I18n.default_locale if current_user.blank? || current_user.profile.blank?
    I18n.locale = current_user.profile.locale.to_sym
  end

  def logged_in?
    !!current_user
  end

  def current_user
    return unless auth_present?
    req = request.headers.fetch('HTTP_AUTHORIZATION').split(' ').last
    return unless req.present? && JsonWebToken.decode(req).first['user_id'].present?
    user = User.find(JsonWebToken.decode(req).first['user_id'])
    @current_user ||= user if user
  end

  def authenticate
    render json: { error: 'unauthorized' }, status: 401 unless logged_in?
  end

  private

  # def token
  #   request.env['HTTP_AUTHORIZATION']
  # end

  def auth_present?
    !!request.headers['HTTP_AUTHORIZATION'].present?
  end
end
