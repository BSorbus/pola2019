class CreateStatements < ActiveRecord::Migration[5.2]
  def change
    create_table :statements do |t|
      t.references :statemenable, polymorphic: true, index: true
      t.string :attached_file
      t.string :file_content_type
      t.string :file_size
      t.text :note, default: ""
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
