class DropMeasurements < ActiveRecord::Migration[5.2]
  def up
    drop_table :measurements if (table_exists? :measurements)
  end

  def down
    #raise ActiveRecord::IrreversibleMigration
  end
end
