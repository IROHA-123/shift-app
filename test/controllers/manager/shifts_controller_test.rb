require "test_helper"

class Manager::ShiftsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get manager_shifts_index_url
    assert_response :success
  end

  test "should get update" do
    get manager_shifts_update_url
    assert_response :success
  end
end
