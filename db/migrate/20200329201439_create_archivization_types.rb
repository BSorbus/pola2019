class CreateArchivizationTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :archivization_types do |t|
      t.string :name, index: true
      t.string :activities, array: true, using: 'gin', default: '{}'

      t.timestamps
    end

    a_type = ArchivizationType.find_or_create_by!(name: "Odczyt") do |ta|
      ta.activities += %w(archive:index archive:show)
      ta.save!
    end
    puts 'CREATED ArchivizationType: ' << a_type.name

    a_type = ArchivizationType.find_or_create_by!(name: "Odczyt i zapis") do |ta|
      ta.activities += %w(archive:index archive:show archive:create archive:update)
      ta.save!
    end
    puts 'CREATED ArchivizationType: ' << a_type.name

    a_type = ArchivizationType.find_or_create_by!(name: "Odczyt, zapis i usuwanie") do |ta|
      ta.activities += %w(archive:index archive:show archive:create archive:update archive:delete archive:work)
      ta.save!
    end
    puts 'CREATED ArchivizationType: ' << a_type.name

  end
end
