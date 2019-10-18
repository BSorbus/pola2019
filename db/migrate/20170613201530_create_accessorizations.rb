class CreateAccessorizations < ActiveRecord::Migration[5.1]
  def change
    create_table :accessorizations do |t|
      t.integer :event_id, index: true
      t.integer :user_id, index: true
      t.integer :role_id, index: true

      t.timestamps      
    end
    add_index :accessorizations, [:event_id, :user_id],     unique: true
    add_index :accessorizations, [:user_id, :event_id],     unique: true
  end
end
