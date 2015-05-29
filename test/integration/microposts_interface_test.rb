require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
  	@user = users(:michael)
  end

  test "micropost interface" do
  	log_in_as(@user)
  	get root_path
  	assert_select 'div.pagination'
  	# Invalid submission
  	assert_no_difference 'Micropost.count' do
  		post microposts_path, micropost: { content: "" }
  	end
  	assert_select 'div#error_explanation'
  	# Valid submission
  	content = "This is a new micropost"
  	assert_difference 'Micropost.count', 1 do
    	post microposts_path, micropost: { content: content }
  	end
  	assert_redirected_to root_path
  	follow_redirect!
  	assert_match content, response.body
  	# Delete a post.
  	assert_select 'a', text: 'delete'
  	first_micropost = @user.microposts.paginate(page: 1).first
  	assert_difference 'Micropost.count', -1 do
  		delete micropost_path(first_micropost)
  	end
  	# Follow a different user.
  	other_user = users(:archer)
  	get user_path(other_user)
  	assert_select 'a', text: 'delete', count: 0
  	first_micropost = other_user.microposts.paginate(page: 1).first
  	assert_no_difference 'Micropost.count' do
  		delete micropost_path(first_micropost)
  	end
  	assert_redirected_to root_path
  end

end
