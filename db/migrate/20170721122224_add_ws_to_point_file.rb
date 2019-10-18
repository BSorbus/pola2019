class AddWsToPointFile < ActiveRecord::Migration[5.1]
  def change
    add_column :point_files, :ws_2, :integer, index: true
    add_column :point_files, :ws_3, :integer, index: true
    add_column :point_files, :ws_4, :integer, index: true
    add_column :point_files, :ws_5, :integer, index: true
    add_column :point_files, :ws_6, :integer, index: true
    add_column :point_files, :ws_7, :integer, index: true
  end
end
