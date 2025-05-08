# シフトを決定する

class Manager::ShiftsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

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

  private

  def require_admin
    redirect_to root_path, alert: "権限がありません" unless current_user.admin?
  end
end
