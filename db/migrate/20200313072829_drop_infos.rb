class DropInfos < ActiveRecord::Migration[5.2]
  def up
    drop_table :infos if (table_exists? :infos)
  end

  def down
    #raise ActiveRecord::IrreversibleMigration
  end
end
