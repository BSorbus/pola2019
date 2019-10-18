class CreateErrands < ActiveRecord::Migration[5.1]
  def change
    create_table :errands do |t|
      t.string :number, index: true
      t.string :principal, index: true
      t.references :errand_status, foreign_key: true
      t.references :errand_type, foreign_key: true
      t.date :order_date, index: true
      t.date :adoption_date, index: true
      t.date :start_date, index: true
      t.date :end_date, index: true
      t.text :note, default: ""

      t.timestamps
    end
  end
end
