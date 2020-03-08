class DropOriginalDocumentations < ActiveRecord::Migration[5.2]
  def up
    drop_table :original_documentations if (table_exists? :original_documentations)
  end

  def down
    #raise ActiveRecord::IrreversibleMigration
  end
end
