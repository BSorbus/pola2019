class DropInspectionProtocols < ActiveRecord::Migration[5.2]
  def up
    drop_table :inspection_protocols if (table_exists? :inspection_protocols)
  end

  def down
    #raise ActiveRecord::IrreversibleMigration
  end
end
