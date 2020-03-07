class BuildFoldersInUser < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|

      dir.up   { 

        admin = User.find_by(email: 'pola@uke.gov.pl')

        User.all.each do |rec|
          upowaznienia = rec.attachments.find_or_create_by!(name_if_folder: "Upoważnienia") do |att|
            att.user = admin
            att.save!
          end
          oswiadczenia = rec.attachments.find_or_create_by!(name_if_folder: "Oświadczenia") do |att|
            att.user = admin
            att.save!
          end
        end

      }

    end
  end
end
