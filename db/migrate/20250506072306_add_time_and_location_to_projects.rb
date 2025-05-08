class AddTimeAndLocationToProjects < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :start_time, :time
    add_column :projects, :end_time, :time
    add_column :projects, :location, :string
  end
end
