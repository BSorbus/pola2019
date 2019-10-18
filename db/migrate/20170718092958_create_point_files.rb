class CreatePointFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :point_files do |t|
      t.references :project, foreign_key: true
      t.date :load_date, index: true
      t.string :load_file
      t.integer :status, index: true
      t.text :note

      t.timestamps
    end
  end
end
