class AddValuesToProjectStatuses < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|

      dir.up   { 
		project_status = ProjectStatus.find_or_create_by!(name: "Rozwiązana umowa")
		puts 'find_or_create PROJECT_STATUS: ' << project_status.name

		project_status = ProjectStatus.find_or_create_by!(name: "Nierealizowany")
		puts 'find_or_create PROJECT_STATUS: ' << project_status.name
      }

      dir.down   { 
		project_status = ProjectStatus.find_by!(name: "Rozwiązana umowa")
		project_status_name = project_status.name if project_status.present?
        if project_status.destroy
          puts 'DESTROYED PROJECT_STATUS: ' << project_status_name
        end

		project_status = ProjectStatus.find_by!(name: "Nierealizowany")
		project_status_name = project_status.name if project_status.present?
        if project_status.destroy
          puts 'DESTROYED PROJECT_STATUS: ' << project_status_name
        end

      }

    end
  end
end
