class CreatePhotos < ActiveRecord::Migration[5.2]
  def change
    create_table :photos do |t|
      t.references :photoable, polymorphic: true
      t.string :attached_file
      t.string :file_content_type
      t.string :file_size
      t.text :note, default: ""
      t.references :user, foreign_key: true

      t.float :latitude, index: true
      t.float :longitude, index: true
      t.datetime :photo_created_at, index: true

      t.timestamps
    end
  end
end
