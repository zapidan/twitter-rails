require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
  	@user = users(:michael)
  end

  test "micropost interface" do
  	log_in_as(@user)
  	get root_path
  	assert_select 'div.pagination'
    assert_select 'input[type=file]'
  	# Invalid submission
  	assert_no_difference 'Micropost.count' do
  		post microposts_path, micropost: { content: "" }
  	end
  	assert_select 'div#error_explanation'
  	# Valid submission
  	content = "This is a new micropost"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image.png')
  	assert_difference 'Micropost.count', 1 do
    	post microposts_path, micropost: { content: content, picture: picture }
  	end
    micropost = assigns(:micropost)
    assert micropost.picture?
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

  test "micropost user show count" do
    log_in_as(@user)
    get user_path(@user)
    assert_match "Microposts (#{ @user.microposts.count })", response.body
    # User with zero microposts
    other_user = users(:mallory)
    log_in_as(other_user)
    get user_path(other_user)
    assert_select 'ol.microposts > li', count: 0 
    other_user.microposts.create!(content: "A micropost")
    get user_path(other_user)
    assert_match "Microposts (#{ other_user.microposts.count })", response.body
  end

  test "micropost sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match "#{ @user.microposts.count } microposts", response.body
    # User with zero microposts
    other_user = users(:mallory)
    log_in_as(other_user)
    get root_path
    assert_match "0 microposts", response.body
    other_user.microposts.create!(content: "A micropost")
    get root_path
    assert_match "#{ other_user.microposts.count } micropost", response.body
  end
end
