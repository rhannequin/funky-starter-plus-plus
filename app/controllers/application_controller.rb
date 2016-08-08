class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    if request.env['HTTP_REFERER'].present?
      redirect_to :back
    else
      redirect_to root_url
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| account_params(u) }
    devise_parameter_sanitizer.for(:account_update) { |u| account_params(u) }
  end

  def account_params(p)
    p.permit %i( name email password password_confirmation current_password )
  end
end
