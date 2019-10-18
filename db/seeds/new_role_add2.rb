puts " "
puts "#####  RUN - new_role_add.rb  #####"
puts " "


role = CreateRoleService.new.business_trip_admin
puts 'CREATED ROLE: ' << role.name

# role = CreateRoleService.new.business_trip_observer
# puts 'CREATED ROLE: ' << role.name


puts " "
puts "#####  END OF - new_role.rb  #####"
puts " "


