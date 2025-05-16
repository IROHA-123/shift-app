class AddFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :employee_id, :string
    add_column :users, :joined_on, :date
    add_column :users, :work_style, :string
    add_column :users, :skill_level, :string
  end
end
