class CreateAttachmentHierarchies < ActiveRecord::Migration[5.2]
  def change
    create_table :attachment_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :attachment_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "attachment_anc_desc_idx"

    add_index :attachment_hierarchies, [:descendant_id],
      name: "attachment_desc_idx"


    reversible do |dir|
      dir.up   { 
        Attachment.rebuild! 
      }
    end
    
  end
end
