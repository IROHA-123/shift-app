class AddRequiredNumberToProjects < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :required_number, :integer
  end
end
