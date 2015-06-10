require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
  	@admin 		= users(:michael)
  	@non_admin  = users(:archer)
  end

  test "index as admin including pagination and delete links" do
  	log_in_as(@admin)
  	get users_path
  	assert_template 'users/index'
  	assert_select 'div.pagination'
  	first_page_of_users = User.paginate(page: 1, per_page: 20)
	  first_page_of_users.each do |user|
    	assert_select 'a[href=?]', user_path(user), text: user.name
    	unless user == @admin
    		assert_select 'a[href=?]', user_path(user), text: 'delete'
    	end
  	end
  	assert_difference 'User.count', -1 do
    	delete user_path(@non_admin)
  	end
  end

  test "index as non_admin" do
  	log_in_as(@non_admin)
  	get users_path
  	assert_template 'users/index'
  	assert_select 'a', text: 'delete', count: 0
  end

  test "should not show non active users" do
    @user = @non_admin
    assert @user.activated?
    @user.toggle!(:activated)
    assert_not @user.activated?
    log_in_as(@admin)
    get user_path(@admin)
    assert_select 'section.user_info'
    assert_select 'h1', text: 'Michael Example'
    get user_path(@user)
    assert_select 'section.user_info', count: 0
    assert_select 'h1', text: 'Sterling Archer', count: 0
    assert_response :redirect
    assert_redirected_to root_url
    assert_not @user.activated?
  end

  test "index shows only activated users" do
    @user = @non_admin
    assert @user.activated?
    @user.toggle!(:activated)
    assert_not @user.activated?
    log_in_as(@admin)
    get users_path
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user) unless user = @user
    end
  end
end
