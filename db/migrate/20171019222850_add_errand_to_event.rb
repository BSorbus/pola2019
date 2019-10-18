class AddErrandToEvent < ActiveRecord::Migration[5.1]
  def change
    add_reference :events, :errand, foreign_key: true
  end
end
