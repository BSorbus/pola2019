class CreateMeasurements < ActiveRecord::Migration[5.2]
  def change
    create_table :measurements do |t|
      t.references :measurementable, polymorphic: true, index: false
      t.string :attached_file
      t.string :file_content_type
      t.string :file_size
      t.text :note, default: ""
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :measurements, [:measurementable_type, :measurementable_id], name: :index_measurements_on_measurementable_type_and_id
  end
end
