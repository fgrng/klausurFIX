require 'test_helper'
 
class SessionHelperTest < ActionView::TestCase
  include SessionsHelper
  

  test "should not set remember_token" do
    assert_not session[:remember_token].present?, "Remember token cookie is present"
  end

  test "should not be signed_in?" do
    assert_not signed_in?, "Signed_in? returnd true"
  end

  # current_user

  test "current_user should return nil" do
    assert_not current_user.present?, "Current user is present"
  end

  # sign_in(user)

  test "should sign in existing user" do
    user = users(:alice)
    sign_in(user)
    assert session[:current_user_id].present?, "Current user id is not present"
    assert current_user.present?, "Current user is not present"
    assert_equal user.id, session[:current_user_id], "Current user id does not match signed in user"
    assert signed_in?, "Signed in returned false"
  end

  test "should set remember token cookie" do
    user = users(:alice)
    sign_in(user)

  end

  # sign_out

  test "should sign out" do
    user = users(:alice)
    sign_in(user)
    sign_out
    assert_not current_user.present?, "Current user is still present"
    assert_not signed_in?, "Signed_in? still returns true"
    assert session.empty?
  end

end
