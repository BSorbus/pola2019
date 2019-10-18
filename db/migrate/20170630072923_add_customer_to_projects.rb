class AddCustomerToProjects < ActiveRecord::Migration[5.1]
  def change
    add_reference :projects, :customer, foreign_key: true
  end
end
