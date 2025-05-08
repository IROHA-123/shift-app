require "test_helper"

class Scheduler::ShiftRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get scheduler_shift_requests_index_url
    assert_response :success
  end

  test "should get create" do
    get scheduler_shift_requests_create_url
    assert_response :success
  end
end
