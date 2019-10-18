class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :number, index: true
      t.date :registration
      t.text :note, default: ""

      t.timestamps
    end
  end
end
