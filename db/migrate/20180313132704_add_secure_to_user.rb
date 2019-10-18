class AddSecureToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :last_activity_at, :datetime
    add_column :users, :expired_at, :datetime
    add_column :users, :password_changed_at, :datetime
  end
end
