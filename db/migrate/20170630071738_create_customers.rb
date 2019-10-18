class CreateCustomers < ActiveRecord::Migration[5.1]
  def change
    create_table :customers do |t|
      t.string :name, index: true
      t.text :note, default: ""

      t.timestamps
    end
  end
end
