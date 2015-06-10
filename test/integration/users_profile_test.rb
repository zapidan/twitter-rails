require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
  	@user = users(:michael)
  end

  test "profile display" do
  	get user_path(@user)
  	assert_template 'users/show'
  	assert_select 'title', full_title(@user.name)
  	assert_select 'h1', text: @user.name
  	assert_select 'h1>img.gravatar'
  	assert_match @user.microposts.count.to_s, response.body
  	assert_select 'div.pagination'
  	@user.microposts.paginate(page: 1, per_page: 10).each do |micropost|
    	assert_match micropost.content, response.body
  	end
  end

  test "stats display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'div.stats'
    assert_select 'a[href=?]', following_user_path(@user)
    assert_match @user.following.count.to_s, response.body
    assert_match "following", response.body
    assert_select 'a > strong', count: 2
    assert_select "a[href=?]", followers_user_path(@user)
    assert_match "followers", response.body
    assert_match @user.followers.count.to_s, response.body
  end
end
