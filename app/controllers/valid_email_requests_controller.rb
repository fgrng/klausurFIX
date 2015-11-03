class ValidEmailRequestsController < ApplicationController

  # Filters

  before_action :check_params_validate, only: [:confirm]

  # Actions

  def confirm
    user = User.find_by_valid_email_token(params[:id])
    if !(user.present?) or user.valid_email
      flash[:danger] = t(:valid_email_error)
      redirect_to controller: 'application', action: 'start'
    else
      user.valid_email = true
      if user.save
        flash[:success] = t(:valid_email_success)
        redirect_to controller: 'application', action: 'dashboard' # TODO
      else
        flash[:danger] = t(:valid_email_error)
        redirect_to controller: 'application', action: 'start'
      end      
    end
  end

  # ---

  private

  # ---

  def check_params_validate
    unless params[:id].present?
      flash[:danger] = t(:valid_email_params_missing)
      redirect_to root_path # TODO      
    end
  end

end
