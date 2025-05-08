# 従業員がスケジュールを登録する場所 scheduler

class Scheduler::ShiftRequestsController < ApplicationController
  before_action :authenticate_user!

  def index
    @projects = Project.order(:work_date)
    @shift_requests = current_user.shift_requests.index_by(&:project_id)
    @shift_assignments = current_user.shift_assignments.index_by(&:project_id)
    
    # カレンダー表示用日付を3か月分生成（月曜始まり、週区切り）---------------------------------
    today = Date.today
    @calendar_days = (0..2).map do |i|
      month = today + i.month
      start_date = month.beginning_of_month
      end_date = month.end_of_month
      # 月曜始まりに調整
      start_date -= (start_date.wday - 1) % 7
      # 日曜日で終わるように日数追加
      days = (start_date..end_date).to_a
      days += ((7 - days.size % 7) % 7).times.map { days.last + 1 }
      days
    end
    
    @this_month_days, @next_month_days, @next2_month_days = @calendar_days
    
    # 3か月分のプロジェクトをまとめて取得し、日付でグループ化
    all_days = @calendar_days.flatten
    @projects_by_date = Project.where(work_date: all_days)
                              .includes(:shift_assignments)
                              .group_by(&:work_date)
  end
  #----------------------------------------------------------------------------------------

  def create
    shift_request = current_user.shift_requests.find_or_initialize_by(project_id: params[:project_id])
    shift_request.status = params[:status]

    if shift_request.save
      redirect_to scheduler_shift_requests_path, notice: "希望を送信しました"
    else
      redirect_to scheduler_shift_requests_path, alert: "エラーが発生しました"
    end
  end

  # モーダル用アクション -------------------------------------------------------------------
  def modal
    ids      = params[:project_ids].to_s.split(",").map(&:to_i)
    projects = Project.where(id: ids)

    # ここを変更：中身だけの partial を返す
    render partial: "scheduler/shift_requests/modal_body", locals: { projects: projects }
  end


  # my_shifts ----------------------------------------------------------------------------
  def my_shift
    today = Date.today
  
    # 本日以降の確定済みシフト
    @shift_assignments = current_user.shift_assignments
                                      .joins(:project)
                                      .where('projects.work_date >= ?', today)
                                      .includes(:project)
  
    # 本日以降の提出済みシフト
    @shift_requests = current_user.shift_requests
                                  .joins(:project)
                                  .where('projects.work_date >= ?', today)
                                  .includes(:project)
  end
  



end
