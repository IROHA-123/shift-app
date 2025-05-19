require "test_helper"

class Manager::AssignmentControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get manager_assignment_index_url
    assert_response :success
  end
end
