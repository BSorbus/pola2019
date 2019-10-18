class AddUserToCustomer < ActiveRecord::Migration[5.1]
  def change
    add_reference :customers, :user, foreign_key: true, index: true
  end
end
