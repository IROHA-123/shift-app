class ConsolidateRequiredWorkersIntoRequiredNumber < ActiveRecord::Migration[7.0]
  def up
    # カラム情報を最新に
    Project.reset_column_information

    # required_number が nil のレコードだけ required_workers の値をコピー
    Project.where(required_number: nil).find_each do |project|
      project.update_column(:required_number, project.required_workers || 0)
    end

    # もう不要になったカラムを削除
    remove_column :projects, :required_workers
  end

  def down
    # rollback 用に一度カラムを復活
    add_column :projects, :required_workers, :integer, default: 0, null: false

    Project.reset_column_information
    # 必要なら required_number の値を戻す
    Project.find_each do |project|
      project.update_column(:required_workers, project.required_number)
    end
  end
end
