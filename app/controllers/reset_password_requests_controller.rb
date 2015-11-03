class ResetPasswordRequestsController < ApplicationController

  # Filters

  before_action :check_params_edit, only: [:edit]
  before_action :check_params_update, only: [:update]
  before_action :check_params_create, only: [:create]

  # Actions

  def create
    user = User.signin_find(params[:reset_password_request][:login])
    if user.present?
      user.reset_password_create_request
      flash[:success] = t(:reset_password_created)
      redirect_to root_path # TODO
    else
      flash[:danger] = t(:reset_password_nouser_error)
      redirect_to root_path # TODO
    end
  end

  def edit
    user = User.find_by_reset_password_token(params[:id])
    if user.present?
      unless user.reset_password_timestamp < 2.hours.ago
        # Render new password form
        render text: "Set new password", layout: 'application' #TODO
      else
        # Reset token has expired
        flash[:danger] = t(:reset_password_old_error)
        redirect_to root_path #TODO
      end
    else
      # No user found
      flash[:danger] = t(:reset_password_nousertoken_error)
      redirect_to root_path #TODO
    end
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      flash[:success] = t(:reset_password_success)
      redirect_to root_path #TODO
    else
      render text: "Set new password", layout: 'application' #TODO
      # render action: 'edit'
    end
  end

  # ---

  private

  # ---

  def user_params
    params.require(:user).permit(:password,:password_confirmation)
  end

  def check_params_create
    unless params[:reset_password_request].present? and
          params[:reset_password_request][:login].present?
      flash[:danger] = t(:reset_password_create_params_missing)
      redirect_to root_path # TODO
    end
  end

  def check_params_edit
    unless params[:id].present?
      flash[:danger] = t(:reset_password_edit_params_missing)
      redirect_to root_path # TODO      
    end
  end

  def check_params_update
    unless params[:id].present? and
          params[:user].present? and
          params[:user][:password].present? and
          params[:user][:password_confirmation].present?
      flash[:danger] = t(:reset_password_update_params_missing)
      redirect_to root_path # TODO      
    end
  end

end
