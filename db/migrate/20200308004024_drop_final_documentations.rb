class DropFinalDocumentations < ActiveRecord::Migration[5.2]
  def up
    drop_table :final_documentations if (table_exists? :final_documentations)
  end

  def down
    #raise ActiveRecord::IrreversibleMigration
  end
end
