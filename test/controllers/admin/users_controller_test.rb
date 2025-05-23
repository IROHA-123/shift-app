require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_users_index_url
    assert_response :success
  end

  test "should get new" do
    get admin_users_new_url
    assert_response :success
  end

  test "should get create" do
    get admin_users_create_url
    assert_response :success
  end
end
