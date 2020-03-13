class DropStatements < ActiveRecord::Migration[5.2]
  def up
    drop_table :statements if (table_exists? :statements)
  end

  def down
    #raise ActiveRecord::IrreversibleMigration
  end
end
