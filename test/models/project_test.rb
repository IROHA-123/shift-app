require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  test "complete_shift_assignments removes requests" do
    project = Project.create!(title: "Test", work_date: Date.today, required_number: 1)
    user = User.create!(email: "user@example.com", password: "password")
    ShiftRequest.create!(user: user, project: project)

    assert_difference ["ShiftAssignment.count", "ShiftRequest.count"], [1, -1] do
      project.complete_shift_assignments!
    end

    assert_equal 0, project.shift_requests.count
    assert_equal user, project.shift_assignments.last.user
  end
end
