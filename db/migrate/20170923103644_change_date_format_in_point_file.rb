class ChangeDateFormatInPointFile < ActiveRecord::Migration[5.1]
  def up
    change_column :point_files, :load_date, :datetime
  end

  def down
    change_column :point_files, :load_date, :date
  end
end
