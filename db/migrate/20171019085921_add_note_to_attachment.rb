class AddNoteToAttachment < ActiveRecord::Migration[5.1]
  def change
    add_column :attachments, :note, :text, default: ""
  end
end
