class BuildFoldersInEvent < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|

      dir.up   { 

        Event.all.each do |rec|
          rec.build_default_attachment_folders(rec.created_at)
        end

      }

    end
  end
end
