class AddOiToPointFile < ActiveRecord::Migration[5.1]
  def change
    add_column :point_files, :oi_2, :string, limit: 16,  index: true
    add_column :point_files, :oi_3, :string, limit: 255, index: true
    add_column :point_files, :oi_4, :string, limit: 100, index: true
    add_column :point_files, :oi_5, :integer,            index: true
    add_column :point_files, :oi_6, :integer,            index: true
    add_column :point_files, :oi_7, :integer,            index: true
    add_column :point_files, :oi_8, :integer,            index: true
    add_column :point_files, :oi_9, :integer,            index: true
    add_column :point_files, :oi_10, :integer,           index: true
  end
end
