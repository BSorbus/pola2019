class AddAreaToProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :area_id, :string, index: true
    add_column :projects, :area_name, :string, index: true
  end
end
