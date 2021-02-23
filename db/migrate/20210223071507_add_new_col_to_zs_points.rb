class AddNewColToZsPoints < ActiveRecord::Migration[5.2]
  def change
    add_column :zs_points, :zs_1022, :string, limit: 100, index: true
    add_column :zs_points, :zs_1023, :string, limit: 100, index: true
  end
end
