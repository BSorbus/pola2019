class CreateArchivizationTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :archivization_types do |t|
      t.string :name, index: true
      t.string :activities, array: true, using: 'gin', default: '{}'

      t.timestamps
    end

    a_type = ArchivizationType.find_or_create_by!(name: "Zarządzanie Składnicą: [Odczyt]") do |ta|
      ta.activities += %w(archive:index archive:show)
      ta.save!
    end
    puts 'CREATED ArchivizationType: ' << a_type.name

    # a_type = ArchivizationType.find_or_create_by!(name: "Składnica: [Odczyt, Zapis]") do |ta|
    #   ta.activities += %w(archive:index archive:show archive:create archive:update)
    #   ta.save!
    # end
    # puts 'CREATED ArchivizationType: ' << a_type.name

    a_type = ArchivizationType.find_or_create_by!(name: "Zarządzanie Składnicą: [Odczyt, Aktualizacja nazwy i opisu, Nadawanie Uprawnień]") do |ta|
      ta.activities += %w(archive:index archive:show archive:update archive:add_remove_archive_group)
      ta.save!
    end
    puts 'CREATED ArchivizationType: ' << a_type.name

    a_type = ArchivizationType.find_or_create_by!(name: "Zarządzanie Składnicą: [Odczyt, Aktualizacja nazwy i opisu, Nadawanie Uprawnień, Usuwanie, Audyt]") do |ta|
      ta.activities += %w(archive:index archive:show archive:update archive:add_remove_archive_group archive:delete archive:work)
      ta.save!
    end
    puts 'CREATED ArchivizationType: ' << a_type.name

    # ------------------ zbiory: -----------------------

    a_type = ArchivizationType.find_or_create_by!(name: "Pliki wewnątrz: [Odczyt]") do |ta|
      ta.activities += %w(archivization:index archivization:show)
      ta.save!
    end
    puts 'CREATED ArchivizationType: ' << a_type.name

    a_type = ArchivizationType.find_or_create_by!(name: "Pliki wewnątrz: [Odczyt, Zapis, Usuwanie]") do |ta|
      ta.activities += %w(archivization:index archivization:show archivization:create archivization:update archivization:delete)
      ta.save!
    end
    puts 'CREATED ArchivizationType: ' << a_type.name

    a_type = ArchivizationType.find_or_create_by!(name: "Pliki wewnątrz: [Odczyt, Zapis, Usuwanie, Audyt]") do |ta|
      ta.activities += %w(archivization:index archivization:show archivization:create archivization:update archivization:delete archivization:work)
      ta.save!
    end
    puts 'CREATED ArchivizationType: ' << a_type.name

  end
end
