class DropOpinions < ActiveRecord::Migration[5.2]
  def up
    drop_table :opinions if (table_exists? :opinions)
  end

  def down
    #raise ActiveRecord::IrreversibleMigration
  end
end
