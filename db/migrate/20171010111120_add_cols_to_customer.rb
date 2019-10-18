class AddColsToCustomer < ActiveRecord::Migration[5.1]
  def change
    add_column :customers, :nip, :string, index: true
    add_column :customers, :regon, :string, index: true
    add_column :customers, :address_city, :string, index: true
    add_column :customers, :address_street, :string, index: true
    add_column :customers, :address_house, :string, index: true
    add_column :customers, :address_number, :string, index: true
    add_column :customers, :address_postal_code, :string
    add_column :customers, :phone, :string
    add_column :customers, :fax, :string
    add_column :customers, :email, :string
    add_column :customers, :epuap, :string
    add_column :customers, :rpt, :string, index: true
  end
end
