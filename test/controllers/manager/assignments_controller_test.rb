require "test_helper"

class Manager::AssignmentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get manager_assignments_index_url
    assert_response :success
  end
end
