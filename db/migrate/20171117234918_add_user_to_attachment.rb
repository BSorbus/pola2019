class AddUserToAttachment < ActiveRecord::Migration[5.1]
  def change
    add_reference :attachments, :user, foreign_key: true, index: true
  end
end
