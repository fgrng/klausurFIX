require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  # Valid email request

  test "should send valid email request" do
    user = users(:bob)
    email = UserMailer.valid_email_request(user).deliver_now
    assert_not ActionMailer::Base.deliveries.empty?
  end

  test "valid email request should have correct data" do
    user = users(:bob)
    email = UserMailer.valid_email_request(user).deliver_now
    assert_equal ['bob@example.com'], email.to
    assert_not email.subject[I18n.t(:valid_email_request_subject)].nil? # check if contains substring
  end

  # Reset password request

  test "should send reset password request" do
    user = users(:alice)
    email = UserMailer.reset_password_request(user).deliver_now
    assert_not ActionMailer::Base.deliveries.empty?
  end

  test "reset password request should have correct data" do
    user = users(:alice)
    email = UserMailer.reset_password_request(user).deliver_now
    assert_equal ['alice@example.com'], email.to
    assert_not email.subject[I18n.t(:reset_password_request_subject)].nil? # check if contains substring
  end

end
