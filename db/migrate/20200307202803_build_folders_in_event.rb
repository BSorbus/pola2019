class BuildFoldersInEvent < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|

      dir.up   { 

        admin = User.find_by(email: 'pola@uke.gov.pl')

        Event.all.each do |rec|
          upowaznienia = rec.attachments.find_or_create_by!(name_if_folder: "Upoważnienia") do |att|
            att.user = admin
            att.save!
          end
          oswiadczenia = rec.attachments.find_or_create_by!(name_if_folder: "Oświadczenia") do |att|
            att.user = admin
            att.save!
          end
          korespondencja = rec.attachments.find_or_create_by!(name_if_folder: "Korespondencja") do |att|
            att.user = admin
            att.save!
          end
          oceny_opinie = rec.attachments.find_or_create_by!(name_if_folder: "Oceny i Opinie") do |att|
            att.user = admin
            att.save!
          end
          protokoly_odbioru = rec.attachments.find_or_create_by!(name_if_folder: "Protokoły Odbioru") do |att|
            att.user = admin
            att.save!
          end
          protokoly_ogledzin = rec.attachments.find_or_create_by!(name_if_folder: "Protokoły Oględzin") do |att|
            att.user = admin
            att.save!
          end
          pomiary = rec.attachments.find_or_create_by!(name_if_folder: "Pomiary") do |att|
            att.user = admin
            att.save!
          end
          info_pokontrolne = rec.attachments.find_or_create_by!(name_if_folder: "Informacje Pokontrolne") do |att|
            att.user = admin
            att.save!
          end
        end

      }

    end
  end
end
