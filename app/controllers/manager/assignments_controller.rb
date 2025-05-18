class Manager::AssignmentsController < ApplicationController
  def index
    # 割り当て状況を取得
    @projects = Project.includes(:shifts).order(work_date: :asc)
  end
end
