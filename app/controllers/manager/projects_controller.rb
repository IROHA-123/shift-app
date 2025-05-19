class Manager::ProjectsController < ApplicationController
  layout "manager"
  before_action :authenticate_user!
  before_action :check_admin

  # ────────────────────────────────────
  # GET /manager/projects
  # 案件一覧
  def index
    @projects = Project.order(work_date: :asc)
  end

  # ────────────────────────────────────
  # GET /manager/projects/new
  # 新規案件登録フォーム
  def new
    @project = Project.new
  end

  # ────────────────────────────────────
  # POST /manager/projects
  # 新規案件登録処理
  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to manager_projects_path, notice: "案件を登録しました"
    else
      render :new
    end
  end

  # ────────────────────────────────────
  # GET /manager/projects/:id/assignment
  # 個別割当編集画面
  def assignment
    @project         = Project.find(params[:id])
    @assigned_users  = @project.shift_assignments.includes(:user)
    @shift_requests  = @project.shift_requests.includes(:user)
  end

  # ────────────────────────────────────
  # PATCH /manager/projects/:id/toggle_request
  # 確定⇔希望 を切り替える Ajax/HTML ハンドラ
  def toggle_request
    @project = Project.find(params[:id])
    user_id  = params.require(:user_id).to_i

    if @project.shift_assignments.exists?(user_id: user_id)
      # 確定済み → 希望 へ戻す
      @project.shift_assignments.find_by(user_id: user_id).destroy
      @project.shift_requests.create!(user_id: user_id)
    elsif @project.shift_requests.exists?(user_id: user_id)
      # 希望  → 確定済み へ移動
      @project.shift_requests.find_by(user_id: user_id).destroy
      @project.shift_assignments.create!(user_id: user_id)
    end

    respond_to do |format|
      format.html do
        # HTML リクエストの場合は詳細画面にリダイレクト
        redirect_to assignment_manager_project_path(@project),
                    notice: "ステータスを切り替えました"
      end
      format.json do
        # Ajax の場合は JSON を返却
        render json: {
          assigned:  @project.shift_assignments.pluck(:user_id),
          requested: @project.shift_requests.pluck(:user_id)
        }
      end
    end
  end

  private

  # Strong Parameters
  def project_params
    params.require(:project)
          .permit(:title, :work_date, :start_time, :end_time, :location, :required_number)
  end

  # 管理者権限チェック
  def check_admin
    redirect_to root_path unless current_user.admin?
  end
end
