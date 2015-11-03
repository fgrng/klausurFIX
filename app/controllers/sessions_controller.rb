# coding: utf-8
class SessionsController < ApplicationController

  # Filters

  before_action :check_params_signin, only: [:signin]

  # Actions

  def signin
    # find user
    user = User.signin_find(params[:session][:login])

    unless user.present?
      # User does not exist
      flash[:danger] = t(:signin_user_not_found)
      redirect_to root_path # TODO
    else
      unless user.valid_email
        # User email address not validated
        flash[:danger] = t(:signin_user_not_valid_email) + " " +
                        view_context.link_to(
                          t(:signin_user_resend_new_email_request),
                          new_valid_email_request_user_path(user)
                        ).to_s
        redirect_to root_path # TODO
      else
        if user.authenticate(params[:session][:password])
          # Correct password! Sign in.
          sign_in user
          redirect_to controller: 'application', action: 'dashboard' # TODO
        else
          # Password not correct.
          flash[:danger] = t(:signin_user_wrong_password)
          redirect_to root_path # TODO
        end
      end
    end
  end

  def signout
    if signed_in?
      sign_out
      flash[:info] = t(:sign_out)
    end
    redirect_to root_path
  end

  # ---

  private

  # ---

  def check_params_signin
    unless params[:session].present? and
          params[:session][:login].present? and
          params[:session][:password].present?
      flash[:danger] = t(:signin_params_missing)
      redirect_to root_path # TODO
    end
  end

end
