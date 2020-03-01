class CreateOriginalDocumentations < ActiveRecord::Migration[5.2]
  def change
    create_table :original_documentations do |t|
      t.references :original_documentionable, polymorphic: true, index: false
      t.string :attached_file
      t.string :file_content_type
      t.string :file_size
      t.text :note, default: ""
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :original_documentations, [:original_documentionable_type, :original_documentionable_id], name: :index_original_documentations_on_type_and_id
  end
end
