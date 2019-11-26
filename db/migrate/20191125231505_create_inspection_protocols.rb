class CreateInspectionProtocols < ActiveRecord::Migration[5.2]
  def change
    create_table :inspection_protocols do |t|
      t.references :inspectionable, polymorphic: true, index: false
      t.string :attached_file
      t.string :file_content_type
      t.string :file_size
      t.text :note, default: ""
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :inspection_protocols, [:inspectionable_type, :inspectionable_id], name: :index_inspection_protocols_on_inspectionable_type_and_id
  end
end
