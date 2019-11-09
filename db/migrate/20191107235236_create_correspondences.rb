class CreateCorrespondences < ActiveRecord::Migration[5.2]
  def change
    create_table :correspondences do |t|
      t.references :correspondenable, polymorphic: true, index: false
      t.string :attached_file
      t.string :file_content_type
      t.string :file_size
      t.text :note, default: ""
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :correspondences, [:correspondenable_type, :correspondenable_id], name: :index_correspondences_on_correspondenable_type_and_id
  end
end
