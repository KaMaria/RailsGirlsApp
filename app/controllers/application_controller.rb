class ApplicationController < ActionController::Base
  require 'will_paginate/array'
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :redesign_variant

  protected

  def configure_permitted_parameters
    editable_fields = [
      :first_name,
      :last_name,
      :password,
      :password_confirmation,
      :current_password,
    ]

    devise_parameter_sanitizer.for(:sign_up) do |person|
      person.permit(editable_fields + [:email, :password, :password_confirmation, :type])
    end

    devise_parameter_sanitizer.for(:account_update) do |person|
      person.permit(editable_fields)
    end
  end

  def ensure_admin_powers
    render_403 unless current_person.admin?
  end

  def ensure_member_powers
    render_403 unless current_person.member_of?(@group) || current_person.admin?
  end

  def render_403
    render file: Rails.root.join('public/403.html'), status: 403
  end

  def redesign_variant
    request.variant = :redesign if params[:redesign]
  end
end
