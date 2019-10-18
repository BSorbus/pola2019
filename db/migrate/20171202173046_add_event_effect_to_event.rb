class AddEventEffectToEvent < ActiveRecord::Migration[5.1]
  def change
    #add_reference :events, :event_effect, foreign_key: true, index: true
    add_reference :events, :event_effect, foreign_key: false, index: true
  end
end
