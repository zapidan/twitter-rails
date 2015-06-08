require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
	def setup
		@user = users(:michael)
	end

	test "layout links non logged in user" do
	    get root_path
	    assert_template 'static_pages/home'
	    assert_select "title", full_title
	    assert_select "a[href=?]", root_path, count: 2
	    assert_select "a[href=?]", help_path
	    assert_select "a[href=?]", about_path
	    assert_select "a[href=?]", contact_path
	    get signup_path
	    assert_select "title", full_title("Sign up")
	    assert_select "a[href=?]", login_path
	    assert_select 'a:match("href", ?)', /./, text: "News"
	    assert_select "a[href=?]", users_path, count: 0
  end

  	test "layout links logged in user" do
    	log_in_as(@user)
    	assert_redirected_to user_path(@user)
    	get root_path
    	assert_select "a[href=?]", root_path, count: 2
    	assert_select "a[href=?]", help_path
	    assert_select "a[href=?]", about_path
	    assert_select "a[href=?]", contact_path
	    assert_select 'a:match("href", ?)', /./, text: "News"
	    assert_select "a[href=?]", login_path, count: 0
	    assert_select "a[href=?]", users_path
	    assert_select "a.dropdown-toggle", "Account"
	    assert_select "a[href=?]", user_path(@user), text: "Profile"
	    assert_select "a[href=?]", edit_user_path(@user), text: "Settings"
	    assert_select "a[href=?]", logout_path, text: "Log out"
  	end
end
