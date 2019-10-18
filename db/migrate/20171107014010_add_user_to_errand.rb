class AddUserToErrand < ActiveRecord::Migration[5.1]
  def change
    add_reference :errands, :user, foreign_key: true, index: true
  end
end
