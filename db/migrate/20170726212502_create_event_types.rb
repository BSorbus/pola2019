class CreateEventTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :event_types do |t|
      t.string :name, index: true
      t.string :activities, array: true, using: 'gin', default: '{}'

      t.timestamps
    end
  end
end
