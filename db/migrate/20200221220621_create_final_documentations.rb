class CreateFinalDocumentations < ActiveRecord::Migration[5.2]
  def change
    create_table :final_documentations do |t|
      t.references :final_documentionable, polymorphic: true, index: false
      t.string :attached_file
      t.string :file_content_type
      t.string :file_size
      t.text :note, default: ""
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :final_documentations, [:final_documentionable_type, :final_documentionable_id], name: :index_final_documentations_on_type_and_id
  end
end
