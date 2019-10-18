puts "##### #####  RUN - customer.rb  ##### #####"
puts " "

require 'csv'

File.open(File.join("db/seeds/files/log", 'customer.log'), 'a+') do |f|
  f.puts "##### #####  031_customer.rb  ##### #####"
  f.puts "Customer.all: #{Customer.all.size}"
  f.puts "... load from db/seeds/files/customer.csv... start..."
end 
puts "Customers all: #{Customer.all.size}"

def get_address_city(data)
  data.present? ? data.split[0] : ""
end
def get_address_street(data)
  data.present? ? data.split[0] : ""
end
def get_address_house(data)
  data.present? ? data : ""
end
def get_address_number(data)
  data.present? ? data : ""
end
def get_address_postal_code(data)
  data.present? ? data : ""
end
def get_regon(data)
  data.present? ? ("000" + data).last(9) : ""
end
def get_rpt(data)
  data.gsub(" ") if data.present?
  if data.to_i.to_s == data || data.to_f.to_s == data
    data
  else
    puts "RPT: #{data} ..is not digit"
    File.open(File.join("db/seeds/files/log", 'customer.log'), 'a+') do |f|
      f.puts "RPT: #{data} ..is not digit"
      f.puts ""
    end 
  end
end

#######################################################################

CSV.foreach("db/seeds/files/customer_win1250.csv", {encoding: "WINDOWS-1250:UTF-8", 
                                            headers: true, 
                                            header_converters: :symbol, 
                                            col_sep: ';'}) do |row|

  @customer = Customer.new(
    name:                  row[:name],  
    nip:                   (row[:nip]).present? ? row[:nip] : "",
    regon:                 get_regon(row[:regon]),
    rpt:                   get_rpt(row[:rpt]),
    address_city:          get_address_city(row[:address_city]),
    address_street:        get_address_street(row[:address_street]),
    address_house:         get_address_house(row[:address_house]),
    address_number:        get_address_number(row[:address_number]),
    address_postal_code:   get_address_postal_code(row[:address_postal_code]),
    phone:                 (row[:phone]).present? ? row[:phone] : "",
    fax:                   (row[:fax]).present? ? row[:fax] : "",
    email:                 (row[:email]).present? ? row[:email] : "",
    epuap:                 (row[:epuap]).present? ? row[:epuap] : "",
    note:                  (row[:note]).present? ? row[:note] : ""
    #user_id:               seek_user(row[:change_user]),
    )

  if @customer.valid?
    # wyswietl info na ekranie
    puts "#{row[:customer_id]} - #{row[:name]} ...load OK"

    #zapisz info do pliku
    File.open(File.join("db/seeds/files/log", 'customer.log'), 'a+') do |f|
      f.puts "CUSTOMER_ID: #{row[:customer_id]} - #{row[:name]} ...load OK"
      f.puts ""
    end 

    @customer.save

  else
    # jeżeli jednak był błąd
    # wyswietl błąd na ekranie
    puts "ERROR(s)"
    puts "      CUSTOMER_ID: #{row[:customer_id]}"
    @customer.errors.full_messages.each do |msg|
      puts " - #{msg}"
    end     
    puts ""

    #zapisz błąd do pliku
    File.open(File.join("db/seeds/files/log", 'customer.error'), 'a+') do |f|
      f.puts "ERROR(s)"
      f.puts "      CUSTOMER_ID: #{row[:customer_id]}"
      @customer.errors.full_messages.each do |msg|
        f.puts " - #{msg}"
      end     
      f.puts ""
    end 
  end

end

#######################################################################

puts "Customers all: #{Customer.all.size}"
File.open(File.join("db/seeds/files/log", 'customer.log'), 'a+') do |f|
  f.puts "Customer.all: #{Customer.all.size}"
  f.puts "##### #####  END ...load from 031_customer.rb  ##### #####"
end 

puts " "
puts "##### #####  END - customer.rb  ##### #####"
