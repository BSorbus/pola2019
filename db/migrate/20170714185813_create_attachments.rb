class CreateAttachments < ActiveRecord::Migration[5.1]
  def change
    create_table :attachments do |t|
      t.references :attachmenable, polymorphic: true, index: true
      t.string :attached_file
      t.string :file_content_type
      t.string :file_size

      t.timestamps
    end
  end
end
