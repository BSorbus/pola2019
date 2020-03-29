class CreateGroupUser < ActiveRecord::Migration[5.1]
  def change
    create_table :groups_users, id: false do |t|
      # t.integer :group_id
      # t.integer :user_id
      t.references :group, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps      
    end
    add_index :groups_users, [:group_id, :user_id],     unique: true
    add_index :groups_users, [:user_id, :group_id],     unique: true
  end
end
