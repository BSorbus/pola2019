puts " "
puts "#####  RUN - new_role_add.rb  #####"
puts " "


role = CreateRoleService.new.customer_attachment_admin
puts 'CREATED ROLE: ' << role.name

role = CreateRoleService.new.customer_attachment_observer
puts 'CREATED ROLE: ' << role.name


#name: "Ocena wniosku"
event_type = EventType.find(1)
event_type.activities = ["role_for_scan:*", "event:index", "event:show", "accessorization:index", "comment:index", "comment:show", "errand:index", "errand:show", "project:index", "project:show", "customer:index", "customer:show", "attachment:customer_index", "attachment:customer_show", "attachment:project_index", "attachment:project_show", "attachment:errand_index", "attachment:errand_show", "attachment:event_index", "attachment:event_show", "point_file:index", "point_file:download", "point_file:show", "proposal_file:index", "proposal_file:download", "proposal_file:show"]
event_type.save!

#name: "Ocena protest"
event_type = EventType.find(2)
event_type.activities = ["event_type_2:*", "event:index", "event:show", "accessorization:index", "comment:index", "comment:show", "errand:index", "errand:show", "project:index", "project:show", "customer:index", "customer:show", "attachment:customer_index", "attachment:customer_show", "attachment:project_index", "attachment:project_show", "attachment:errand_index", "attachment:errand_show", "attachment:event_index", "attachment:event_show", "point_file:index", "point_file:download", "point_file:show", "proposal_file:index", "proposal_file:download", "proposal_file:show"]
event_type.save!

#name: "Analiza Sąd"
event_type = EventType.find(3)
event_type.activities = ["event_type_3:*", "event:index", "event:show", "accessorization:index", "comment:index", "comment:show", "errand:index", "errand:show", "project:index", "project:show", "customer:index", "customer:show", "attachment:customer_index", "attachment:customer_show", "attachment:project_index", "attachment:project_show", "attachment:errand_index", "attachment:errand_show", "attachment:event_index", "attachment:event_show", "point_file:index", "point_file:download", "point_file:show", "proposal_file:index", "proposal_file:download", "proposal_file:show"]
event_type.save!

#name: "Opinia zmian"
event_type = EventType.find(4)
event_type.activities = ["event_type_4:*", "event:index", "event:show", "accessorization:index", "comment:index", "comment:show", "errand:index", "errand:show", "project:index", "project:show", "customer:index", "customer:show", "attachment:customer_index", "attachment:customer_show", "attachment:project_index", "attachment:project_show", "attachment:errand_index", "attachment:errand_show", "attachment:event_index", "attachment:event_show", "point_file:index", "point_file:download", "point_file:show", "proposal_file:index", "proposal_file:download", "proposal_file:show"]
event_type.save!

#name: "Kontrola realizacja"
event_type = EventType.find(5)
event_type.activities = ["event_type_5:*", "event:index", "event:show", "accessorization:index", "comment:index", "comment:show", "errand:index", "errand:show", "project:index", "project:show", "customer:index", "customer:show", "attachment:customer_index", "attachment:customer_show", "attachment:project_index", "attachment:project_show", "attachment:errand_index", "attachment:errand_show", "attachment:event_index", "attachment:event_show", "point_file:index", "point_file:download", "point_file:show", "proposal_file:index", "proposal_file:download", "proposal_file:show"]
event_type.save!

#name: "Kontrola zakończenie"
event_type = EventType.find(6)
event_type.activities = ["event_type_6:*", "event:index", "event:show", "accessorization:index", "comment:index", "comment:show", "errand:index", "errand:show", "project:index", "project:show", "customer:index", "customer:show", "attachment:customer_index", "attachment:customer_show", "attachment:project_index", "attachment:project_show", "attachment:errand_index", "attachment:errand_show", "attachment:event_index", "attachment:event_show", "point_file:index", "point_file:download", "point_file:show", "proposal_file:index", "proposal_file:download", "proposal_file:show"]
event_type.save!

#name: "Kontrola trwałość"
event_type = EventType.find(7)
event_type.activities = ["event_type_7:*", "event:index", "event:show", "accessorization:index", "comment:index", "comment:show", "errand:index", "errand:show", "project:index", "project:show", "customer:index", "customer:show", "attachment:customer_index", "attachment:customer_show", "attachment:project_index", "attachment:project_show", "attachment:errand_index", "attachment:errand_show", "attachment:event_index", "attachment:event_show", "point_file:index", "point_file:download", "point_file:show", "proposal_file:index", "proposal_file:download", "proposal_file:show"]
event_type.save!

#name: "Analiza danych"
event_type = EventType.find(8)
event_type.activities = ["event_type_8:*", "event:index", "event:show", "accessorization:index", "comment:index", "comment:show", "errand:index", "errand:show", "project:index", "project:show", "customer:index", "customer:show", "attachment:customer_index", "attachment:customer_show", "attachment:project_index", "attachment:project_show", "attachment:errand_index", "attachment:errand_show", "attachment:event_index", "attachment:event_show", "point_file:index", "point_file:download", "point_file:show", "proposal_file:index", "proposal_file:download", "proposal_file:show"]
event_type.save!

#name: "Hurt cenniki"
event_type = EventType.find(9)
event_type.activities = ["event_type_9:*", "event:index", "event:show", "accessorization:index", "comment:index", "comment:show", "errand:index", "errand:show", "project:index", "project:show", "customer:index", "customer:show", "attachment:customer_index", "attachment:customer_show", "attachment:project_index", "attachment:project_show", "attachment:errand_index", "attachment:errand_show", "attachment:event_index", "attachment:event_show", "point_file:index", "point_file:download", "point_file:show", "proposal_file:index", "proposal_file:download", "proposal_file:show"]
event_type.save!

#name: "Inne"
event_type = EventType.find(10)
event_type.activities = ["event_type_10:*", "event:index", "event:show", "accessorization:index", "comment:index", "comment:show", "errand:index", "errand:show", "project:index", "project:show", "customer:index", "customer:show", "attachment:customer_index", "attachment:customer_show", "attachment:project_index", "attachment:project_show", "attachment:errand_index", "attachment:errand_show", "attachment:event_index", "attachment:event_show", "point_file:index", "point_file:download", "point_file:show", "proposal_file:index", "proposal_file:download", "proposal_file:show"]
event_type.save!


puts " "
puts "#####  END OF - new_role.rb  #####"
puts " "


