class CreateRoads < ActiveRecord::Migration[5.2]
  def change
    create_table :roads do |t|
      t.references :business_trip, foreign_key: true
      t.string :from
      t.datetime :start_date_time
      t.string :to
      t.datetime :end_date_time
      t.references :transport_type, foreign_key: true
      t.decimal :cost, precision: 8, scale: 2, default: 0.00

      t.timestamps
    end
  end
end
