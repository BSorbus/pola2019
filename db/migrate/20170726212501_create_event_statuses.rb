class CreateEventStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :event_statuses do |t|
      t.string :name, index: true

      t.timestamps
    end
  end
end
