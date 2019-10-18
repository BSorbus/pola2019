class CreateTransports < ActiveRecord::Migration[5.2]
  def change
    create_table :transports do |t|
      t.references :business_trip, foreign_key: true
      t.references :transport_type, foreign_key: true

      t.timestamps
    end
  end
end
