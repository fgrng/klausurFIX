class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Handle CSRF Forgery
  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    # sign_out if signed_in?
    flash[:danger] = t(:csrf_forgery)
    redirect_to root_path
  end

  # Make Helper methods available in controllers
  include SessionsHelper

  # Set locale before action
  before_action :set_locale

  # Set custom flash types to work with twitter bootstrap
  add_flash_types :success, :info, :warning, :danger

  # Actions

  def start
    render text: t(:hello_world), layout: 'application' #TODO
  end

  def dashboard
    unless require_signin
      render text: t(:hello_dashboard), layout: 'application' #TODO
    end
  end

  # Set locale in default url option
  def default_url_options(options = {})
    { locale: I18n.locale || I18n.default_locale }.merge options
  end

  # ---

  private

  # ---

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def require_signin
    unless signed_in?
      flash[:danger] = t(:require_signin)
      redirect_to controller: 'application', action: 'start'
    end
  end
  
end
