class AddParentIdToAttachment < ActiveRecord::Migration[5.2]
  def change
    add_column :attachments, :parent_id, :integer, index: true
    add_column :attachments, :name_if_folder, :string
    add_column :attachments, :name, :string

    reversible do |dir|
      dir.up   { 

  	    Attachment.all.each do |rec|
          rec.update_columns(name: rec.attached_file_identifier)
        end

      }
    end

  end
end
