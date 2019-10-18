class AddEventTypeToEvents < ActiveRecord::Migration[5.1]
  def change
    add_reference :events, :event_type, foreign_key: true
  end
end
