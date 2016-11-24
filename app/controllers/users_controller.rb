class UsersController < ApplicationController

  # Filters

  before_action :set_user, except: [:index, :new, :create]
  before_action :require_signin, except: [:new, :create, :new_valid_email_request]
  
  # Actions

  def index
    @users = User.all
    @d_users = @users.decorate
  end

  def show
    # TODO
  end

  def new
    @user = User.new
  end

  def create
    # force presence of password_confirmation
    params[:users][:password_confirmation] = "" unless params[:users][:password_confirmation].present?

    user = User.new(users_params)
    if user.save
      flash[:success] = t(:users_create_success)
      redirect_to controller: 'application', action: 'dashboard'
    else
      render action: 'new'
    end
  end

  def edit
    # TODO
  end

  def update
    if @user.update(users_params)
      flash[:success] = t(:users_update_success)
      redirect_to controller: 'application', action: 'dashboard' # TODO
    else
      render action: 'edit'
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t(:users_destroy_success)
      logger.debug("test")
      redirect_to root_path #TODO
    else
      flash[:danger] = t(:users_destroy_failure)
      redirect_to root_path #TODO
    end
  end

  def new_valid_email_request
    unless @user.valid_email
      @user.valid_email_create_request
      flash[:info] = t(:valid_email_resend)
      redirect_to root_path #TODO
    else
      flash[:danger] = t(:valid_email_resend_already_valid)
      redirect_to root_path #TODO
    end
  end

  # ---

  private

  # ---

  def users_params
    params.require(:users).permit(:username,
                                  :email,
                                  :password,
                                  :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
    @d_user = @user.decorate
  end

end
