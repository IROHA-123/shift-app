class Manager::ProjectsController < ApplicationController
  layout "manager"
  before_action :authenticate_user!
  before_action :check_admin

  def index
    @projects = Project.order(work_date: :asc)
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to manager_projects_path, notice: "案件を登録しました"
    else
      render :new
    end
  end

  def assignment
    @project = Project.find(params[:id])
    @assigned_users = @project.shift_assignments.includes(:user)
    @shift_requests = @project.shift_requests.includes(:user)
  end

  # ----------------------------------------------------------------
  private

  def project_params
    params.require(:project).permit(:title, :work_date, :start_time, :end_time, :location, :required_number)
  end

  def check_admin
    redirect_to root_path unless current_user.admin?
  end
end
