class BuildFoldersInErrand < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|

      dir.up   { 

        # admin = User.find_by(email: 'pola@uke.gov.pl')

        # Errand.all.each do |rec|
        #   korespondencja = rec.attachments.find_or_create_by!(name_if_folder: "Korespondencja") do |att|
        #     att.user = admin
        #     att.save!
        #   end
        # end

      }

    end
  end
end
