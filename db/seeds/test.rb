puts " "
puts "#####  RUN - test.rb  #####"
puts " "

#doc = Nokogiri::XML(xml_doc)
#puts '------------------------------------------'
#doc.remove_namespaces! # Remove namespaces from xml to make it clean
#print doc


# def display_xml(filename)
#   xsd_doc = Nokogiri::XML::Schema(File.open("db/seeds/"+filename)) do |config|
#   #doc = Nokogiri::XML::Schema(File.open("db/seeds/"+filename)) do |config|
#     config.strict.nonet
#   end
#   print xsd_doc
# end




# #display_xml("rodzaj_wysylki.xml")
# display_xml("adres.xsd")

Role.destroy_all
user = User.last
role = CreateRoleService.new.role_admin
puts 'CREATED ROLE: ' << role.name
user.roles << role
puts "ADD ROLE: #{role.name}   TO USER: #{user.email}"

role = CreateRoleService.new.role_observer
puts 'CREATED ROLE: ' << role.name


role = CreateRoleService.new.user_admin
puts 'CREATED ROLE: ' << role.name
user.roles << role
puts "ADD ROLE: #{role.name}   TO USER: #{user.email}"

role = CreateRoleService.new.user_observer
puts 'CREATED ROLE: ' << role.name


role = CreateRoleService.new.customer_admin
puts 'CREATED ROLE: ' << role.name
user.roles << role
puts "ADD ROLE: #{role.name}   TO USER: #{user.email}"

role = CreateRoleService.new.customer_observer
puts 'CREATED ROLE: ' << role.name

role = CreateRoleService.new.project_admin
puts 'CREATED ROLE: ' << role.name
user.roles << role
puts "ADD ROLE: #{role.name}   TO USER: #{user.email}"

role = CreateRoleService.new.project_observer
puts 'CREATED ROLE: ' << role.name


role = CreateRoleService.new.accessorization_manager
puts 'CREATED ROLE: ' << role.name

role = CreateRoleService.new.accessorization_observer
puts 'CREATED ROLE: ' << role.name

role = CreateRoleService.new.role_for_projects_publisher
puts 'CREATED ROLE: ' << role.name

role = CreateRoleService.new.role_for_projects_writer
puts 'CREATED ROLE: ' << role.name

puts " "
puts "#####  END OF - test.rb  #####"
puts " "


