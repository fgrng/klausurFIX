require 'test_helper'

class ValidEmailRequestsControllerTest < ActionController::TestCase

  test "should get show (validate)" do
    get :confirm, id: "foo"
    assert_response :redirect
  end

  # Errors

  test "should redirect on non existing user" do
    get :confirm, id: "foo"
    assert_response :redirect
    assert_equal I18n.t(:valid_email_error), flash[:danger]
  end

  test "should redirect on already validatet user" do
    user = users(:alice)
    get :confirm, id: "my_token"
    assert_response :redirect
    assert_equal I18n.t(:valid_email_error), flash[:danger]
  end

  test "should redirect on invalid user" do
    user = users(:bob)
    user.update_attribute(:username, "alice") # skip validation
    get :confirm, id: user.valid_email_token
    assert_response :redirect
    assert_equal I18n.t(:valid_email_error), flash[:danger]
  end

  # Success

  test "should succeed" do
    user = users(:bob)
    get :confirm, id: user.valid_email_token
    assert_response :redirect
    assert_equal I18n.t(:valid_email_success), flash[:success]
  end

  test "valid_email should be true after success" do
    user = users(:bob)
    assert_not user.valid_email
    get :confirm, id: user.valid_email_token
    user.reload
    assert user.valid_email, "Valid email is false after success"
  end

end
