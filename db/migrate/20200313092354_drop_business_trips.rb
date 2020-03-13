class DropBusinessTrips < ActiveRecord::Migration[5.2]
  def up
    drop_table :business_trips if (table_exists? :business_trips)
  end

  def down
    #raise ActiveRecord::IrreversibleMigration
  end
end
