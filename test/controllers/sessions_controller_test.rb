require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

  # Signin

  test "should post signin" do
    post :signin
    assert_response :redirect
  end

  test "should redirect on signin without session params" do
    post :signin, session: { login: "alice" } 
    assert_response :redirect, "Did not redirect on missing password"
    assert_equal I18n.t(:signin_params_missing), flash[:danger]

    post :signin, session: { password: "password"}
    assert_response :redirect, "Did not redirect on missing username"
    assert_equal I18n.t(:signin_params_missing), flash[:danger]

    post :signin
    assert_response :redirect, "Did not redirect on missing session hash parameter"
    assert_equal I18n.t(:signin_params_missing), flash[:danger]
  end

  test "should redirect on non existing user" do
    post :signin, session: { login: "eve", password: "password"}    
    assert_response :redirect, "Did not redirect on non existing user"
    assert_equal I18n.t(:signin_user_not_found), flash[:danger]
  end

  test "should redirect on email not validated" do
    post :signin, session: { login: "bob", password: "bbbbbbbb"}    
    assert_response :redirect, "Did not redirect on email not validated"
    assert_not flash[:danger][I18n.t(:signin_user_not_valid_email)].nil? # flash contains valid_email error
  end

  test "should redirect on wrong password" do
    post :signin, session: { login: "alice", password: "not_my_password"}    
    assert_response :redirect, "Did not redirect on wrong password"
    assert_equal I18n.t(:signin_user_wrong_password), flash[:danger]
  end

  test "should redirect on correct credentials" do
    post :signin, session: { login: "alice", password: "aaaaaaaa" }
    assert_response :redirect, "Did not redirect on correct credentials"
    assert_redirected_to( { controller: 'application', action: "dashboard" }, "Did not redirect on correct credentials")
  end

  test "should set correct user id on correct credentials" do
    post :signin, session: { login: "alice", password: "aaaaaaaa" }
    user = users(:alice)
    assert_equal user.id, session[:current_user_id], "Current user id not correct"
  end

  # Sign out
  
  test "should get signout" do
    post :signin, session: { login: "alice", password: "aaaaaaaa" }
    delete :signout
    assert_response :redirect, "Did not redirect on signout"
  end

  test "should delete current user id on signout" do
    post :signin, session: { login: "alice", password: "aaaaaaaa" }
    delete :signout
    assert_not session[:current_user_id].present?
  end

end
