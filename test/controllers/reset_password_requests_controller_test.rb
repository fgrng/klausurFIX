require 'test_helper'

class ResetPasswordRequestsControllerTest < ActionController::TestCase

  # --- Create ---

  # Errors

  test "should not create on missing params" do
    post :create, reset_password_request: ""
    assert_response :redirect
    assert_equal I18n.t(:reset_password_create_params_missing), flash[:danger]
  end

  test "should not create on non existing user" do
    post :create, reset_password_request: { login: "eve" }
    assert_response :redirect
    assert_equal I18n.t(:reset_password_nouser_error), flash[:danger]
  end

  # Success

  test "should create" do
    post :create, reset_password_request: { login: "alice" }
    assert_response :redirect
    assert_equal I18n.t(:reset_password_created), flash[:success]
  end

  # --- Edit ---

  # Errors

  test "should redirect on non existing user" do
    get :edit, id: "foo"
    assert_response :redirect
    assert_equal I18n.t(:reset_password_nousertoken_error), flash[:danger]
  end

  test "should redirect on old token" do
    user = users(:alice)
    user.update_attribute(:reset_password_timestamp, Time.current - 3.hours)
    get :edit, id: user.reset_password_token
    assert_response :redirect
    assert_equal I18n.t(:reset_password_old_error), flash[:danger]
  end

  # Success

  test "should edit" do
    user = users(:alice)
    user.update_attribute(:reset_password_timestamp, Time.current - 1.hours)
    get :edit, id: user.reset_password_token
    assert_response :success
  end
  
  # --- Update ---

  # Errors

  test "should not update on wrong confirmation" do
    user = users(:alice)
    old_password = user.password_digest
    patch :update, id: user.id, user: { password: "bbbbbbbb", password_confirmation: "cccccccc" }
    assert_response :success # paradox
    assert_equal old_password, user.reload.password_digest
  end

  # Success

  test "should update" do
    user = users(:alice)
    old_password = user.password_digest
    patch :update, id: user.id, user: { password: "bbbbbbbb", password_confirmation: "bbbbbbbb" }
    assert_response :redirect # paradox
    assert_not_equal old_password, user.reload.password_digest
    assert_equal I18n.t(:reset_password_success), flash[:success]
  end

end
