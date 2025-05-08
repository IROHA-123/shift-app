module ApplicationHelper
  def japanese_date_with_weekday(date)
    wdays = %w(日 月 火 水 木 金 土)
    "#{date.month}月#{date.day}日（#{wdays[date.wday]}）"
  end
end
