class Project < ApplicationRecord

  # ユーザーが複数のシフト申請を持つ関係を構築
  has_many :shift_requests
  has_many :shift_assignments

  # work_dateを必須にする
  validates :work_date, presence: true


end
