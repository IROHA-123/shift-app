class CreateShiftAssignments < ActiveRecord::Migration[7.1]
  def change
    create_table :shift_assignments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
