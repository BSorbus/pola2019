class DropTransportTypes < ActiveRecord::Migration[5.2]
  def up
    drop_table :transport_types if (table_exists? :transport_types)
  end

  def down
    #raise ActiveRecord::IrreversibleMigration
  end
end
