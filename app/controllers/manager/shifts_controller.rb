class Manager::ShiftsController < Manager::BaseController

  def index
    @projects = Project.includes(:shift_requests, :shift_assignments, :users).order(:work_date)
    @users = User.where(role: "employee")
  end

  def update
    assignment = ShiftAssignment.find_or_initialize_by(user_id: params[:user_id], project_id: params[:project_id])
    if assignment.save
      redirect_to manager_shifts_path, notice: "シフトを確定しました"
    else
      redirect_to manager_shifts_path, alert: "保存に失敗しました"
    end
  end

end
