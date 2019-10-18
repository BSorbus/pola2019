class AddDpToPointFile < ActiveRecord::Migration[5.1]
  def change
    add_column :point_files, :dp_2, :string, limit: 250, index: true
    add_column :point_files, :dp_3, :string, limit:  13, index: true #10 NIP - - -
    add_column :point_files, :dp_4, :string, limit:  10, index: true
    add_column :point_files, :dp_5, :string, limit: 100, index: true
    add_column :point_files, :dp_6, :string, limit: 250, index: true
    add_column :point_files, :dp_7, :string, limit:  50, index: true
    add_column :point_files, :dp_8, :string, limit:   6, index: true
  end
end
