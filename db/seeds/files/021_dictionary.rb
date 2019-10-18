puts "##### #####  RUN - dictionary.rb  ##### #####"
puts " "


enrollment = Enrollment.find_or_create_by!(name: "I Nabór-2016", note: "", user_id: 1)
puts 'find_or_create ENROLLMENT: ' << enrollment.name

enrollment = Enrollment.find_or_create_by!(name: "II Nabór-2017", note: "", user_id: 1)
puts 'find_or_create ENROLLMENT: ' << enrollment.name

puts " "


project_status = ProjectStatus.find_or_create_by!(name: "Zarejestrowany")
puts 'find_or_create PROJECT_STATUS: ' << project_status.name

project_status = ProjectStatus.find_or_create_by!(name: "Ocena")
puts 'find_or_create PROJECT_STATUS: ' << project_status.name

project_status = ProjectStatus.find_or_create_by!(name: "Protest")
puts 'find_or_create PROJECT_STATUS: ' << project_status.name

project_status = ProjectStatus.find_or_create_by!(name: "Skarga sądowa")
puts 'find_or_create PROJECT_STATUS: ' << project_status.name

project_status = ProjectStatus.find_or_create_by!(name: "Odrzucony pozytywny")
puts 'find_or_create PROJECT_STATUS: ' << project_status.name

project_status = ProjectStatus.find_or_create_by!(name: "Odrzucony negatywny formalna")
puts 'find_or_create PROJECT_STATUS: ' << project_status.name

project_status = ProjectStatus.find_or_create_by!(name: "Odrzucony negatywny mer. I")
puts 'find_or_create PROJECT_STATUS: ' << project_status.name

project_status = ProjectStatus.find_or_create_by!(name: "Odrzucony negatywny mer. II")
puts 'find_or_create PROJECT_STATUS: ' << project_status.name

project_status = ProjectStatus.find_or_create_by!(name: "Realizowany")
puts 'find_or_create PROJECT_STATUS: ' << project_status.name

project_status = ProjectStatus.find_or_create_by!(name: "Trwałość")
puts 'find_or_create PROJECT_STATUS: ' << project_status.name

project_status = ProjectStatus.find_or_create_by!(name: "Zakończony")
puts 'find_or_create PROJECT_STATUS: ' << project_status.name

puts " "


errand_status = ErrandStatus.find_or_create_by!(name: "Przekazane do UKE")
puts 'find_or_create ERRAND_STATUS: ' << errand_status.name

errand_status = ErrandStatus.find_or_create_by!(name: "W realizacji")
puts 'find_or_create ERRAND_STATUS: ' << errand_status.name

errand_status = ErrandStatus.find_or_create_by!(name: "Weryfikacja")
puts 'find_or_create ERRAND_STATUS: ' << errand_status.name

errand_status = ErrandStatus.find_or_create_by!(name: "Zakończone")
puts 'find_or_create ERRAND_STATUS: ' << errand_status.name

puts " "


event_status = EventStatus.find_or_create_by!(name: "Otwarte")
puts 'find_or_create EVENT_STATUS: ' << event_status.name

event_status = EventStatus.find_or_create_by!(name: "Weryfikacja UKE")
puts 'find_or_create EVENT_STATUS: ' << event_status.name

event_status = EventStatus.find_or_create_by!(name: "Zamknięte")
puts 'find_or_create EVENT_STATUS: ' << event_status.name

event_status = EventStatus.find_or_create_by!(name: "Weryfikacja CPPC")
puts 'find_or_create EVENT_STATUS: ' << event_status.name

event_status = EventStatus.find_or_create_by!(name: "Anulowane")
puts 'find_or_create EVENT_STATUS: ' << event_status.name

puts " "


event_effect = EventEffect.create!(name: "Bez wyniku")
puts 'find_or_create EVENT_EFFECT: ' << event_effect.name

event_effect = EventEffect.create!(name: "Negatywny")
puts 'find_or_create EVENT_EFFECT: ' << event_effect.name

event_effect = EventEffect.create!(name: "Pozytywny")
puts 'find_or_create EVENT_EFFECT: ' << event_effect.name

event_effect = EventEffect.create!(name: "Pozytywny z uwagami")
puts 'find_or_create EVENT_EFFECT: ' << event_effect.name

event_effect = EventEffect.create!(name: "Pozytywny&Negatywny")
puts 'find_or_create EVENT_EFFECT: ' << event_effect.name

puts " "


event_type = EventType.find_or_create_by!(name: "Ocena") do |role|
  role.activities += %w(rating:* event:index event:show accessorization:index comment:index comment:show project:index project:show customer:index customer:show attachment:project_index attachment:project_show attachment:event_index attachment:event_show point_file:index point_file:download point_file:show proposal_file:index proposal_file:download proposal_file:show)
  role.save!
end
puts 'find_or_create EVENT_TYPE: ' << event_type.name

event_type = EventType.find_or_create_by!(name: "Ocena protest") do |role|
  role.activities += %w(opiniowanie2:* rating:index rating:show event:index event:show accessorization:index comment:index comment:show project:index project:show customer:index customer:show attachment:project_index attachment:project_show attachment:event_index attachment:event_show point_file:index point_file:download point_file:show proposal_file:index proposal_file:download proposal_file:show)
  role.save!
end
puts 'find_or_create EVENT_TYPE: ' << event_type.name

event_type = EventType.find_or_create_by!(name: "Analiza Sąd") do |role|
  role.activities += %w(for_role_scan:*)
  role.save!
end
puts 'find_or_create EVENT_TYPE: ' << event_type.name

event_type = EventType.find_or_create_by!(name: "Opinia zmian") do |role|
  role.activities += %w(for_role_scan:*)
  role.save!
end
puts 'find_or_create EVENT_TYPE: ' << event_type.name

event_type = EventType.find_or_create_by!(name: "Kontrola realizacja") do |role|
  role.activities += %w(for_role_scan:*)
  role.save!
end
puts 'find_or_create EVENT_TYPE: ' << event_type.name

event_type = EventType.find_or_create_by!(name: "Kontrola zakończenie") do |role|
  role.activities += %w(for_role_scan:*)
  role.save!
end
puts 'find_or_create EVENT_TYPE: ' << event_type.name

event_type = EventType.find_or_create_by!(name: "Kontrola trwałość") do |role|
  role.activities += %w(for_role_scan:*)
  role.save!
end
puts 'find_or_create EVENT_TYPE: ' << event_type.name

event_type = EventType.find_or_create_by!(name: "Analiza danych") do |role|
  role.activities += %w(for_role_scan:* event:index event:show accessorization:index comment:index comment:show project:index project:show customer:index customer:show attachment:project_index attachment:project_show attachment:event_index attachment:event_show point_file:index point_file:download point_file:show proposal_file:index proposal_file:download proposal_file:show)
  role.save!
end
puts 'find_or_create EVENT_TYPE: ' << event_type.name

event_type = EventType.find_or_create_by!(name: "Hurt cenniki") do |role|
  role.activities += %w(for_role_scan:*)
  role.save!
end
puts 'find_or_create EVENT_TYPE: ' << event_type.name

event_type = EventType.find_or_create_by!(name: "Inne") do |role|
  role.activities += %w(for_role_scan:*)
  role.save!
end
puts 'find_or_create EVENT_TYPE: ' << event_type.name




puts " "
puts "##### #####  END - dictionary.rb  ##### #####"
