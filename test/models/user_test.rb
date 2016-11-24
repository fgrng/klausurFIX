require 'test_helper'

class UserTest < ActiveSupport::TestCase

  # Username

  test "should not save user without username" do
    user = users(:alice)
    user.username = nil
    assert_not user.save, "Saved user without username."
  end

  test "should not save user with special characters in username" do
    user = users(:alice)
    user.username = "al!ce"
    assert_not user.save, "Saved user with special characters in username."
  end

  test "should not save user with short username username" do
    user = users(:alice)
    user.username = "al"
    assert_not user.save, "Saved user with short username"
  end

  test "should not save user with long username username" do
    user = users(:alice)
    user.username = "alicealicealicealicealice"
    assert_not user.save, "Saved user with long username"
  end

  test "should not save user with existing username" do
    user = users(:alice)

    user.username = "bob"
    assert_not user.save, "Saved user with existing username"

    user.username = "Bob"
    assert_not user.save, "Saved user with existing username (case insensitive)"
  end

  test "should strip whitespaces in username" do
    user = users(:alice)
    user.username = "  alice"
    user.save
    assert_equal "alice", user.username, "Didn't strip whitespace at beginning"

    user.username = "alice  "
    user.save
    assert_equal "alice", user.username, "Didn't strip whitespace at the end"

    user.username = " a li  ce"
    user.save
    assert_equal "alice", user.username, "Didn't strip whitespace in the middle"
  end
  
  # Email Adress

  test "should not save user without email" do
    user = users(:alice)
    user.email = nil
    assert_not user.save, "Saved user without email."
  end

  test "should downcase email" do
    user = users(:alice)
    user.email = "Alice@Example.com"
    user.save
    assert_equal "alice@example.com", user.email, "Saved user without downcasing email."
  end

  test "should strip whitespaces in email" do
    user = users(:alice)
    user.email = "  alice@example.com"
    user.save
    assert_equal "alice@example.com", user.email, "Didn't strip whitespace at beginning"

    user.email = "alice@example.com  "
    user.save
    assert_equal "alice@example.com", user.email, "Didn't strip whitespace at the end"

    user.email = " ali  ce@ examp le. com"
    user.save
    assert_equal "alice@example.com", user.email, "Didn't strip whitespace in the middle"
  end
  
  test "should not save user with existing email" do
    user = users(:alice)

    user.username = "bob@example.com"
    assert_not user.save, "Saved user with existing email"

    user.username = "Bob@Example.com"
    assert_not user.save, "Saved user with existing email (case insensitive)"
  end

  # Password
  
  test "should not save user without password digest" do
    user = users(:alice)
    user.password_digest = nil
    assert_not user.save, "Saved user without password digest."
  end

  test "should not create user without password" do
    user = User.new(username: "charlie", email: "charlie@example.com", valid_email: false)
    assert_not user.save, "Saved user without password."
  end

  test "should create user without password confirmation" do
    user = User.new(username: "charlie", email: "charlie@example.com", valid_email: false)
    user.password = "aaaaaaaa"
    assert user.save, "Didn't save user without password confirmation"
  end

  test "should not create user with empty password confirmation" do
    user = User.new(username: "charlie", email: "charlie@example.com", valid_email: false)
    user.password = "aaaaaaaa"
    user.password_confirmation = ""
    assert_not user.save, "Saved user with empty password confirmation"
  end
  
  test "should not create user with password mismatch" do
    user = User.new(username: "charlie", email: "charlie@example.com", valid_email: false)
    user.password = "aaaaaaaa"
    user.password_confirmation = "bbbbbbbb"
    assert_not user.save, "Saved user with password mismatch"
  end

  test "should not save user with short password" do
    user = User.new(username: "charlie", email: "charlie@example.com", valid_email: false)
    user.password = "aaa"
    user.password_confirmation = "aaa"
    assert_not user.save, "Saved user with short password."
  end

  # Valid Email

  test "should not save user with unset valid email boolean" do
    user = users(:alice)
    user.valid_email = nil
    assert_not user.save, "Saved user without valid email boolean"
  end

  # Authentication

  test "should not authenticate without password" do
    user = users(:alice)
    assert_not user.authenticate(nil), "Authenticated without password (nil)"
    assert_not user.authenticate(""), "Authenticated without password (empty)"
  end

  test "should not authenticate with wrong password" do
    user = users(:alice)
    assert_not user.authenticate("bbbbbbbb"), "Authenticated with wrong password"
  end

  test "should authenticate with correct password" do
    user = users(:alice)
    assert user.authenticate("aaaaaaaa"), "Did not authenticated with correct password"
  end

  # Find and Authentication

  test "should authenticate non existing user" do
    assert_not User.find_by_email("eve@example.com").try(:authenticate, "aaaaaaaa"), "Authenticated non existing users"
  end

  test "should authenticate existing user" do
    assert User.find_by_email("alice@example.com").try(:authenticate, "aaaaaaaa"), "Did not authenticated existing user"
  end

  test "should not authenticate existing user with wrong password" do
    assert_not User.find_by_email("alice@example.com").try(:authenticate, "bbbbbbbb"), "Authenticated existing user with wrong password"
  end

  test "should signin_find user by username" do
    assert user = User.signin_find("alice"), "Did not find signin_find user by username."
  end

  test "should signin_find user by email" do
    assert user = User.signin_find("alice@example.com"), "Did not find signin_find user by email."
  end

  test "should not signin_find user by wrong email/username" do
    assert_not user = User.signin_find("eve"), "Found non existing user with signin_find"
    assert_not user = User.signin_find("eve@example.com"), "Found non existing user with signin_find"
  end

  # Valid Email Request

  test "should change valid email token on request create" do
    user = users(:alice)
    old_token = user.valid_email_token
    user.valid_email_create_request
    assert_not user.valid_email_token.blank?, "Valid email token was not set on new request."
    assert_not_equal old_token, user.valid_email_token, "Valid email token did not change on new request."
  end

  # Reset Password Request

  test "should change reset password token/timestamp on request create" do
    user = users(:alice)
    old_token = user.reset_password_token
    old_timestamp = user.reset_password_timestamp
    user.reset_password_create_request

    assert_not user.reset_password_token.blank?, "Reset password token was not set on new request."
    assert_not_equal old_token, user.reset_password_token, "Reset password token did not change on new request."
    assert_not user.reset_password_timestamp.blank?, "Reset password timestamp was not set on new request."
    assert_not_equal old_timestamp, user.reset_password_timestamp, "Reset password timestamp did not change on new request."
  end

end
