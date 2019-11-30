class CreateDocumentations < ActiveRecord::Migration[5.2]
  def change
    create_table :documentations do |t|
      t.references :documentationable, polymorphic: true, index: false
      t.string :attached_file
      t.string :file_content_type
      t.string :file_size
      t.text :note, default: ""
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :documentations, [:documentationable_type, :documentationable_id], name: :index_documentations_on_documentationable_type_and_id
  end
end
