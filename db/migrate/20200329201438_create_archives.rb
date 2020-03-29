class CreateArchives < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|

      dir.up   { 
        create_table :archives do |t|
          t.string :name
          t.text :note, default: ""
          t.references :user, foreign_key: true

          t.timestamps
        end

        role = CreateRoleService.new.archive_admin
        puts 'CREATED ROLE: ' << role.name

        role = CreateRoleService.new.archive_observer
        puts 'CREATED ROLE: ' << role.name

      }

      dir.down   { 

        role = CreateRoleService.new.archive_admin
        role_name = role.name
        if role.destroy
          puts 'DESTROYED ROLE: ' << role_name
        end

        role2 = CreateRoleService.new.archive_observer
        role2_name = role2.name
        if role2.destroy
          puts 'DESTROYED ROLE: ' << role2_name
        end

        drop_table :archives if (table_exists? :archives)
      }

    end
  end
end
