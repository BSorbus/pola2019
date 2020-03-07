class BuildFoldersInProject < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|

      dir.up   { 

        admin = User.find_by(email: 'pola@uke.gov.pl')

        Project.all.each do |rec|
          dokumentacja_budowlana = rec.attachments.find_or_create_by!(name_if_folder: "Dokumentacja Budowlana") do |att|
            att.user = admin
            att.save!
          end
          dokumentacja_pierwotna = rec.attachments.find_or_create_by!(name_if_folder: "Dokumentacja Pierwotna") do |att|
            att.user = admin
            att.save!
          end
          dokumentacja_ostateczna = rec.attachments.find_or_create_by!(name_if_folder: "Dokumentacja Ostateczna na KOP") do |att|
            att.user = admin
            att.save!
          end
          umowa_aneksy = rec.attachments.find_or_create_by!(name_if_folder: "Umowa i Aneksy") do |att|
            att.user = admin
            att.save!
          end
          brakowanie = rec.attachments.find_or_create_by!(name_if_folder: "Brakowanie") do |att|
            att.user = admin
            att.save!
          end
          dane_geo = rec.attachments.find_or_create_by!(name_if_folder: "Dane GEO") do |att|
            att.user = admin
            att.save!
          end
        end

      }

    end
  end
end
