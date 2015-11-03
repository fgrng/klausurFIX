module SessionsHelper

  # Session - Current User
  
  def sign_in(user)
    if user.present?
      # Session Fixation - Countermeasure
      # reset_session

      session[:current_user_id] = user.id
      self.current_user = user
      return true
    else
      return false
    end
  end

  def signed_in?
    !self.current_user.nil?
  end

  def sign_out
    session.clear if session
    self.current_user = nil
    # Session Fixation - Countermeasure
    # reset_session
  end

  def current_user=(user)
    @_current_user = user
  end

  def current_user
    @_current_user || User.find_by_id(session[:current_user_id])
  end

end
