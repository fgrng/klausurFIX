class UserMailer < ApplicationMailer

  def valid_email_request(user)
    @user = user
    mail :to => @user.email, :subject => "[klausurFIX] " + I18n.t(:valid_email_request_subject)
  end

  def reset_password_request(user)
    @user = user
    mail :to => @user.email, :subject => "[klausurFIX] " + I18n.t(:reset_password_request_subject)
  end

end
