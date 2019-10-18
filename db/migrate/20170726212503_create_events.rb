class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :title, index: true
      t.boolean :all_day
      t.datetime :start_date, index: true
      t.datetime :end_date, index: true
      t.integer :project_id, index: true
      t.text :note, default: ""

      t.timestamps
    end
  end
end
