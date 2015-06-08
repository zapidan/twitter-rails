require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
  	@user = users(:michael)
  end

  test "unsuccessful edit" do
  	log_in_as(@user)
  	get edit_user_path(@user)
  	assert_template 'users/edit'
  	patch user_path(@user), user: { name: " ",
  									email: "foo@invalid", 
  									password: 				"foo",
  									password_confirmation:  "bar" }
  	assert_template 'users/edit'
  end

  test "successful edit with friendly forwarding on subsequent logins" do
  	get edit_user_path(@user)
    assert_equal edit_user_url, session[:forwarding_url]
  	assert_redirected_to login_path
  	assert_not flash[:danger].empty?
    assert_equal edit_user_url, session[:forwarding_url]
  	log_in_as(@user)
    assert session[:forwarding_url].nil?
  	assert_redirected_to edit_user_path(@user)
  	name = "Foo Bar"
  	email = "foo@bar.com"
  	patch user_path(@user), user: { name: name,
  									email: email,
  									password: 			   "",
  									password_confirmation: "" }
  	assert_not flash[:success].empty?
  	assert_redirected_to @user
  	@user.reload
  	assert_equal name, @user.name
  	assert_equal email, @user.email
    log_in_as(@user)
    assert_redirected_to user_path(@user)
    assert session[:forwarding_url].nil?
  end
end
