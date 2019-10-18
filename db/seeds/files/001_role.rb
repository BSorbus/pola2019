puts "##### #####  RUN - role.rb  ##### #####"
puts " "

role = CreateRoleService.new.work_observer
puts 'CREATED ROLE: ' << role.name


user = CreateAdminService.new.call
puts 'CREATED ADMIN USER: ' << user.email 



role = CreateRoleService.new.role_admin
puts 'CREATED ROLE: ' << role.name
unless user.roles.where(id: role.id).any?
  user.roles << role 
  puts "ADD ROLE: #{role.name}   TO USER: #{user.email}"
end

role = CreateRoleService.new.role_observer
puts 'CREATED ROLE: ' << role.name


role = CreateRoleService.new.user_admin
puts 'CREATED ROLE: ' << role.name
unless user.roles.where(id: role.id).any?
  user.roles << role
  puts "ADD ROLE: #{role.name}   TO USER: #{user.email}"
end

role = CreateRoleService.new.user_observer
puts 'CREATED ROLE: ' << role.name


role = CreateRoleService.new.user_attachment_admin
puts 'CREATED ROLE: ' << role.name

role = CreateRoleService.new.user_attachment_observer
puts 'CREATED ROLE: ' << role.name


role = CreateRoleService.new.customer_admin
puts 'CREATED ROLE: ' << role.name

role = CreateRoleService.new.customer_observer
puts 'CREATED ROLE: ' << role.name


role = CreateRoleService.new.enrollment_admin
puts 'CREATED ROLE: ' << role.name

role = CreateRoleService.new.enrollment_observer
puts 'CREATED ROLE: ' << role.name


role = CreateRoleService.new.enrollment_attachment_admin
puts 'CREATED ROLE: ' << role.name

role = CreateRoleService.new.enrollment_attachment_observer
puts 'CREATED ROLE: ' << role.name


role = CreateRoleService.new.project_admin
puts 'CREATED ROLE: ' << role.name

role = CreateRoleService.new.project_observer
puts 'CREATED ROLE: ' << role.name


role = CreateRoleService.new.project_attachment_admin
puts 'CREATED ROLE: ' << role.name

role = CreateRoleService.new.project_attachment_observer
puts 'CREATED ROLE: ' << role.name


role = CreateRoleService.new.project_point_file_admin
puts 'CREATED ROLE: ' << role.name

role = CreateRoleService.new.project_point_file_observer
puts 'CREATED ROLE: ' << role.name


role = CreateRoleService.new.project_proposal_file_admin
puts 'CREATED ROLE: ' << role.name

role = CreateRoleService.new.project_proposal_file_observer
puts 'CREATED ROLE: ' << role.name


role = CreateRoleService.new.errand_admin
puts 'CREATED ROLE: ' << role.name

role = CreateRoleService.new.errand_observer
puts 'CREATED ROLE: ' << role.name


role = CreateRoleService.new.errand_attachment_admin
puts 'CREATED ROLE: ' << role.name

role = CreateRoleService.new.errand_attachment_observer
puts 'CREATED ROLE: ' << role.name


role = CreateRoleService.new.event_admin
puts 'CREATED ROLE: ' << role.name

role = CreateRoleService.new.event_observer
puts 'CREATED ROLE: ' << role.name


role = CreateRoleService.new.event_attachment_admin
puts 'CREATED ROLE: ' << role.name

role = CreateRoleService.new.event_attachment_observer
puts 'CREATED ROLE: ' << role.name


role = CreateRoleService.new.comment_admin
puts 'CREATED ROLE: ' << role.name

role = CreateRoleService.new.comment_observer
puts 'CREATED ROLE: ' << role.name

role = CreateRoleService.new.rating_admin
puts 'CREATED ROLE: ' << role.name

role = CreateRoleService.new.rating_observer
puts 'CREATED ROLE: ' << role.name


role = CreateRoleService.new.accessorization_manager
puts 'CREATED ROLE: ' << role.name

role = CreateRoleService.new.accessorization_observer
puts 'CREATED ROLE: ' << role.name

role = CreateRoleService.new.role_for_event_observer
puts 'CREATED ROLE: ' << role.name

role = CreateRoleService.new.role_for_event_performer
puts 'CREATED ROLE: ' << role.name

puts " "
puts "##### #####  END - role.rb  ##### #####"