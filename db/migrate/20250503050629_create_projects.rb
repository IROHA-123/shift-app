class CreateProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :projects do |t|
      t.string :title
      t.date :work_date
      t.integer :required_workers

      t.timestamps
    end
  end
end
