class AddAttachmentsFileSizeSum < ActiveRecord::Migration[5.2]
  def change
    add_column :customers, :attachments_file_size_sum, :integer, default: 0, null: false
    add_column :enrollments, :attachments_file_size_sum, :integer, default: 0, null: false
    add_column :errands, :attachments_file_size_sum, :integer, default: 0, null: false
    add_column :events, :attachments_file_size_sum, :integer, default: 0, null: false
    add_column :projects, :attachments_file_size_sum, :integer, default: 0, null: false
    add_column :users, :attachments_file_size_sum, :integer, default: 0, null: false
  end
end
