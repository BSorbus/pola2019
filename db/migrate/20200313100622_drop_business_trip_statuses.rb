class DropBusinessTripStatuses < ActiveRecord::Migration[5.2]
  def up
    drop_table :business_trip_statuses if (table_exists? :business_trip_statuses)
  end

  def down
    #raise ActiveRecord::IrreversibleMigration
  end
end
