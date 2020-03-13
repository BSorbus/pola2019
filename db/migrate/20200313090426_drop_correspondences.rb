class DropCorrespondences < ActiveRecord::Migration[5.2]
  def up
    drop_table :correspondences if (table_exists? :correspondences)
  end

  def down
    #raise ActiveRecord::IrreversibleMigration
  end
end
