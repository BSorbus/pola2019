puts " "
puts "#####  RUN - add_role.rb  #####"
puts " "


#u = CreateAdminService.new.call_simple('bogdan.jarzab@uke.gov.pl', 'Bogdan Jarząb', '1qazXSW@')
#u = User.last
#u.confirm

User.where.not(id: 1).all.each do |u|
  Role.where(special: true).all.each do |r|
    u.roles << r
    puts "ADD ROLE: #{r.name}   TO USER: #{u.name}"
  end
end

puts " "
puts "#####  END OF - add_role.rb  #####"
puts " "
