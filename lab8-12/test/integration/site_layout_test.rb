require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:naf)
  end

  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", login_path

    log_in_as(@user)
    get root_path
    assert_select "a[href=?]", users_path

    get edit_user_path(@user)
    assert_template 'users/edit'

    get user_path(@user)
    assert_template 'users/show'

    get users_path(@user)
    assert_select "a[data-method=?]", 'delete'

    get signup_path
    assert_select "title", full_title("Sign up")
  end
end
