class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|

      dir.up   { 
        create_table :groups do |t|
          t.string :name
          t.text :note, default: ""

          t.timestamps
        end

        role = CreateRoleService.new.group_admin
        puts 'CREATED ROLE: ' << role.name

        role = CreateRoleService.new.group_observer
        puts 'CREATED ROLE: ' << role.name

      }

      dir.down   { 

        role = CreateRoleService.new.group_admin
        role_name = role.name
        if role.destroy
          puts 'DESTROYED ROLE: ' << role_name
        end

        role2 = CreateRoleService.new.group_observer
        role2_name = role2.name
        if role2.destroy
          puts 'DESTROYED ROLE: ' << role2_name
        end

        drop_table :groups if (table_exists? :groups)
      }

    end
  end
end


