class DropRoads < ActiveRecord::Migration[5.2]
  def up
    drop_table :roads if (table_exists? :roads)
  end

  def down
    #raise ActiveRecord::IrreversibleMigration
  end
end
