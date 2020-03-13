class DropProtocols < ActiveRecord::Migration[5.2]
  def up
    drop_table :protocols if (table_exists? :protocols)
  end

  def down
    #raise ActiveRecord::IrreversibleMigration
  end
end
