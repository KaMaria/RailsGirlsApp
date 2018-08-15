class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from NoSuchCountry, with: :bad_request

  protected

  def configure_permitted_parameters
    editable_fields = [
      :first_name,
      :last_name,
      :password,
      :password_confirmation,
      :current_password,
    ]

    devise_parameter_sanitizer.permit(:sign_up) do |person|
      person.permit(editable_fields + [:email, :password, :password_confirmation, :type])
    end

    devise_parameter_sanitizer.permit(:account_update) do |person|
      person.permit(editable_fields)
    end
  end

  def ensure_admin_powers
    render_403 unless current_person.admin?
  end

  def ensure_member_powers
    render_403 unless current_person.member_of?(@group) || current_person.admin?
  end

  def ensure_group_admin_powers
    render_403 unless current_person.admin? || current_person.admin_member_of?(@group)
  end

  def render_403
    render file: Rails.root.join('public/403.html'), status: 403
  end

  def render_404
    render file: Rails.root.join('public/404.html'), status: 404
  end

  def bad_request
    render file: Rails.root.join('public/400.html'), status: 400
  end

  def trim_params(params)
    params.each { |_, val| val.strip! if val.respond_to?(:strip!) }
  end

end
