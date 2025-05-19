class Manager::AssignmentsController < ApplicationController
  layout "manager"
  before_action :authenticate_user!
  before_action :check_admin

  # ────────────────────────────────────
  # 一覧表示：割り当て状況をテーブル形式で編集できるようにする
  # GET /manager/assignments
  # ────────────────────────────────────
  def index
    # 各案件と、その案件に紐づく shift_assignments をまとめて取得
    @projects = Project.includes(:shift_assignments).order(work_date: :asc)

    # プルダウンで選ぶ「ユーザー一覧」を用意
    # [["田中 はな", 1], ["鈴木 太郎", 2], ...] の形に
    @users = User.order(:name).pluck(:name, :id)

    # テーブルの列数を決めるため、必要人数の最大値を計算
    @max_slots = @projects.map(&:required_number).max || 0
  end

  # ────────────────────────────────────
  # 一括更新：プルダウンで選んだメンバーをまとめて保存する
  # PATCH /manager/assignments/update_members
  # ────────────────────────────────────
  def update_members
    # params[:assignments] の形は
    # { "3" => ["1","2",""], "4" => ["2","",""] } のようになっているはず
    assignments_params.each do |project_id, user_ids|
      project = Project.find(project_id)

      # トランザクションで安全に置き換え
      Project.transaction do
        # まず古い割り当てをクリア
        project.shift_assignments.destroy_all

        # 空文字を除き、重複を取り除いてから再作成
        user_ids.reject(&:blank?).uniq.each do |uid|
          project.shift_assignments.create!(user_id: uid)
        end
      end
    end

    redirect_to manager_assignments_path, notice: "配置メンバーを更新しました"
  end

  private

  # ストロングパラメータで :assignments キーを許可
  # 内部は { "project_id" => [user_id, ...], ... } のハッシュ
  def assignments_params
    params.require(:assignments).permit!
  end

  # 管理者じゃない場合はトップへ
  def check_admin
    redirect_to root_path unless current_user.admin?
  end
end
