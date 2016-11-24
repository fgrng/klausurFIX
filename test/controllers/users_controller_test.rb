require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  include SessionsHelper

  def setup
    # require login
    @user = users(:alice)
    sign_in @user
  end

  def teardown
    sign_out
  end

  # Require login

  test "should fail index" do
    sign_out
    get :index
    assert_response :redirect
    assert_nil assigns(:users)
    assert_nil assigns(:d_users)
    assert_equal I18n.t(:require_signin), flash[:danger]
  end

  test "should fail show" do
    sign_out
    get :show, id: @user.id
    assert_response :redirect
    assert_equal I18n.t(:require_signin), flash[:danger]
  end

  test "should fail edit" do
    sign_out
    get :edit, id: @user.id
    assert_response :redirect
    assert_equal I18n.t(:require_signin), flash[:danger]
  end

  test "should fail update" do
    sign_out
    patch :update, id: @user.id
    assert_response :redirect
    assert_equal I18n.t(:require_signin), flash[:danger]
  end

  # --- index
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
    assert_not_nil assigns(:d_users)
  end

  # -- show

  test "should get show" do
    get :show, id: @user.id
    assert_response :success
    assert_not_nil assigns(:user)
    assert_not_nil assigns(:d_user)
  end

  test "should get show diff user" do
    get :show, id: users(:bob).id
    assert_response :success
    assert_not_nil assigns(:user)
    assert_not_nil assigns(:d_user)
  end

  # --- new

  test "should get new" do
    sign_out
    get :new
    assert_response :success
    assert_not_nil assigns(:user)
  end

  # --- create

  test "should post create" do
    sign_out
    assert_difference('User.count') do
      post :create, users: { username: "charlie",
                             email: "charlie@example.com",
                             password: "cccccccc",
                             password_confirmation: "cccccccc"}
    end
  end

  test "should not post create with missing confirmation" do
    sign_out
    assert_no_difference('User.count') do
      post :create, users: { username: "charlie",
                             email: "charlie@example.com",
                             password: "cccccccc" }
    end
  end

  # --- edit

  test "should get edit" do
    get :edit, id: @user.id
    assert_response :success
    assert_not_nil assigns(:user)
  end

  test "should get edit diff user" do
    get :edit, id: users(:bob).id
    assert_response :success
    assert_not_nil assigns(:user)
  end

  # --- update

  test "should patch update" do
    patch :update, id: @user.id, users: { username: "charlie" }
    assert_response :redirect
    assert_equal I18n.t(:users_update_success), flash[:success]
    assert_equal "charlie", users(:alice).reload.username
  end

  test "should patch update diff user" do
    patch :update, id: users(:bob).id, users: { username: "charlie" }
    assert_response :redirect
    assert_equal I18n.t(:users_update_success), flash[:success]
    assert_equal "charlie", users(:bob).reload.username
  end

  # --- delete

  test "should delete destroy" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user.id
    end
    assert_equal I18n.t(:users_destroy_success), flash[:success]
    assert_response :redirect
  end

  test "should delete destroy diff user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: users(:bob).id
    end
    assert_equal I18n.t(:users_destroy_success), flash[:success]
    assert_response :redirect
  end

  # --- valid email request
  
  test "should get new_valid_email_request on invalid user" do
    sign_out
    old_token = users(:bob).valid_email_token
    get :new_valid_email_request, id: users(:bob).id
    assert_equal I18n.t(:valid_email_resend), flash[:info]
    assert_not_equal old_token, users(:bob).reload.valid_email_token
    assert_response :redirect
  end

  test "should not get new_valid_email_request on valid user" do
    sign_out
    get :new_valid_email_request, id: @user.id
    assert_equal I18n.t(:valid_email_resend_already_valid), flash[:danger]
    assert_response :redirect
  end


end
