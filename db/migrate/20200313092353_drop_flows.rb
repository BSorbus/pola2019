class DropFlows < ActiveRecord::Migration[5.2]
  def up
    drop_table :flows if (table_exists? :flows)
  end

  def down
    #raise ActiveRecord::IrreversibleMigration
  end
end
