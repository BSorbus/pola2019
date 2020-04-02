class CreateArchivizations < ActiveRecord::Migration[5.2]
  def change
    create_table :archivizations do |t|
      t.integer :archive_id, index: true
      t.integer :group_id, index: true
      t.integer :archivization_type_id, index: true

      t.timestamps      
    end
    # add_index :archivizations, [:archive_id, :group_id],     unique: true
    # add_index :archivizations, [:group_id, :archive_id],     unique: true
  end
end
