require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:naf)
    @other = users(:malory4)
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

  test "statistics" do
    log_in_as(@user)
    get user_path(@user)
    assert_template 'users/show'
    assert_difference '@user.following.count', +1 do
      post relationships_path, params: { followed_id: @other.id , follower_id: @user.id}
    end

    assert_difference '@user.following.count', -1 do
      delete relationship_path(@user.active_relationships.find_by(followed_id: @other.id)), xhr: true
    end
  end
end
