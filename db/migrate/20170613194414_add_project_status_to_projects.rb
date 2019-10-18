class AddProjectStatusToProjects < ActiveRecord::Migration[5.1]
  def change
    #add_column :projects, :project_status_id, :int
    add_reference :projects, :project_status, foreign_key: true, default: 1
  end
end
