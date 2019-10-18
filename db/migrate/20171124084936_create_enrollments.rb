class CreateEnrollments < ActiveRecord::Migration[5.1]
  def change
    create_table :enrollments do |t|
      t.string :name
      t.text :note, default: ""
      t.references :user, foreign_key: true, index: true

      t.timestamps
    end
  end
end
