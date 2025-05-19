class Manager::AssignmentsController < ApplicationController
  layout "manager"
  def index
    # 割り当て状況を取得
    @projects = Project.includes(:shift_assignments).order(work_date: :asc)
  end
end
