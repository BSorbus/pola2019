class AddOi11ToPointFile < ActiveRecord::Migration[5.2]
  def change
    add_column :point_files, :oi_11, :integer
    add_column :point_files, :oi_1009, :integer
    add_column :point_files, :oi_1010, :integer
  end
end
