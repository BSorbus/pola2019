class AddNotificationToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :notification_by_email, :boolean, default: true
  end
end
