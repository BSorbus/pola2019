class DropTransports < ActiveRecord::Migration[5.2]
  def up
    drop_table :transports if (table_exists? :transports)
  end

  def down
    #raise ActiveRecord::IrreversibleMigration
  end
end
