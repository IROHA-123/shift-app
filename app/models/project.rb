class Project < ApplicationRecord

  # ユーザーが複数のシフト申請を持つ関係を構築
  has_many :shift_requests, dependent: :destroy
  has_many :shift_assignments, dependent: :destroy

  # work_dateを必須にする
  validates :work_date, presence: true

  # 必要人数に達するまで希望者を確定者に変換する例
  def complete_shift_assignments!
    needed = required_number - shift_assignments.count
    return if needed <= 0

    requests = shift_requests.limit(needed)

    requests.each do |req|
      shift_assignments.create!(user: req.user)
    end

    # 割り当て完了後、対応する申請を削除
    requests.destroy_all
  end

end
