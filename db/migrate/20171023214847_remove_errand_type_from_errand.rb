class RemoveErrandTypeFromErrand < ActiveRecord::Migration[5.1]
  def change
    remove_reference :errands, :errand_type, foreign_key: true
  end
end
