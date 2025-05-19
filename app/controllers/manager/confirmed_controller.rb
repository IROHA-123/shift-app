module Manager
  class ConfirmedController < ApplicationController
    layout "manager"

    def index
      # ── (1) 期間パラメータを受け取る or 今月をデフォルトに
      period = params[:period] || Time.zone.today.strftime("%Y%m")
      
      # ── (2) 文字列 "YYYYMM" → Date オブジェクトの月初・月末
      @start_date = Date.strptime(period, "%Y%m").beginning_of_month
      @end_date   = @start_date.end_of_month

      # ── (3) 前月・翌月用の period 文字列も作成
      @prev_period = (@start_date << 1).strftime("%Y%m")  # １ヶ月戻す
      @next_period = (@start_date >> 1).strftime("%Y%m")  # １ヶ月進める

      # ── (4) その期間内の案件＋確定シフト＆ユーザーをまとめて取得
      @projects = Project
        .includes(shift_assignments: :user)
        .where(work_date: @start_date..@end_date)
        .order(work_date: :asc)
    end
    #------------------------------------------------------------------  
    # もし update アクションが必要ならこちらも定義# app/controllers/manager/confirmed_controller.rb
module Manager
  class ConfirmedController < ApplicationController
    layout "manager"

    # 確定シフト一覧表示
    def index
      # ── (1) period パラメータを YYYYMM 形式で受け取る or 今月を使う
      period = params[:period] || Time.zone.today.strftime("%Y%m")

      # ── (2) Date オブジェクトに変換して月初・月末を取得
      @start_date = Date.strptime(period, "%Y%m").beginning_of_month
      @end_date   = @start_date.end_of_month

      # ── (3) 前月・翌月リンク用の period 文字列
      @prev_period = (@start_date << 1).strftime("%Y%m")  # 1ヶ月戻す
      @next_period = (@start_date >> 1).strftime("%Y%m")  # 1ヶ月進める

      # ── (4) 期間内のプロジェクトを、確定シフト＋ユーザー込みで取得
      @projects = Project
        .includes(shift_assignments: :user)
        .where(work_date: @start_date..@end_date)
        .order(work_date: :asc)
    end

    # 確定シフト更新（PATCH）
    def update
      assignment = ShiftAssignment.find(params[:id])
      if assignment.update(shift_assignment_params)
        flash[:notice] = "更新しました"
      else
        flash[:alert]  = "更新に失敗しました"
      end

      # 更新後は同じ月の一覧へ戻る
      redirect_to manager_confirmations_path(period: params[:period])
    end

    private

    # Strong Parameters: フォームから許可する属性を列挙
    def shift_assignment_params
      params.require(:shift_assignment).permit(
        :user_id,
        :project_id
      )
    end
  end
end

    def update
      assignment = ShiftAssignment.find(params[:id])
      if assignment.update(shift_assignment_params)
        flash[:notice] = "更新しました"
      else
        flash[:alert] = "更新に失敗しました"
      end
      # 更新後も同じ月の一覧へ戻る
      redirect_to manager_confirmations_path(period: params[:period])
    end

    private
    #------------------------------------------------------------------
    def shift_assignment_params
      params.require(:shift_assignment).permit(:user_id, :project_id)
    end




  end
end
