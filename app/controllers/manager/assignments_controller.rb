class Manager::AssignmentsController < ApplicationController
  layout "manager"
  before_action :authenticate_user!
  before_action :check_admin

  # ────────────────────────────────────
  # 割り当て一覧画面
  # GET /manager/assignments
  # ────────────────────────────────────
  def index
    # 1 表示期間を取得（デフォルトは今月）
    period = params[:period] || Time.zone.today.strftime("%Y%m")
    @start_date = Date.strptime(period, "%Y%m").beginning_of_month
    @end_date   = @start_date.end_of_month

    # 2 前月・翌月の period を計算（画面右上のリンク用）
    @prev_period = (@start_date - 1.month).strftime("%Y%m")
    @next_period = (@start_date + 1.month).strftime("%Y%m")

    # 3 表示期間内の案件のみ取得（N+1対策あり）
    @projects = Project
      .includes(:shift_assignments)
      .where(work_date: @start_date..@end_date)  # ← これがポイント！
      .order(work_date: :asc)

    # 4 プルダウン用のユーザー一覧（名前とID）
    @users = User.order(:name).pluck(:name, :id)

    # 5 必要人数の最大値（表の列数を決めるため）
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
