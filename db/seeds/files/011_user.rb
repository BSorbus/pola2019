puts "##### #####  RUN - user.rb  ##### #####"
puts " "

require 'csv'

File.open(File.join("db/seeds/files/log", 'user.log'), 'a+') do |f|
  f.puts "##### #####  011_user.rb  ##### #####"
  f.puts "User.all: #{User.all.size}"
  f.puts "... load from db/seeds/files/user.csv... start..."
end 
puts "Users all: #{User.all.size}"


#######################################################################

CSV.foreach("db/seeds/files/users.csv", {encoding: "WINDOWS-1250:UTF-8", 
                                            headers: true, 
                                            header_converters: :symbol, 
                                            col_sep: ';'}) do |row|

  user = CreateAdminService.new.call_simple(row[:email].downcase, row[:imie] + ' ' + row[:nazwisko], '1qazXSW@', '')
  puts 'find_or_create USER: ' << user.email

  #zapisz info do pliku
  File.open(File.join("db/seeds/files/log", 'user.log'), 'a+') do |f|
    f.puts "USER_ID: #{user.id} - #{user.email} ...load OK"
    f.puts ""
  end 


end
#######################################################################

puts "Users all: #{User.all.size}"
File.open(File.join("db/seeds/files/log", 'user.log'), 'a+') do |f|
  f.puts "User.all: #{User.all.size}"
  f.puts "##### #####  END ...load from 011_user.rb  ##### #####"
end 

puts " "
puts "##### #####  END - user.rb  ##### #####"
