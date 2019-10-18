puts " "
puts "#####  RUN - business_trip_dict.rb  #####"
puts " "


BusinessTripStatus.find_or_create_by!(name: "Wniosek")
BusinessTripStatus.find_or_create_by!(name: "Zakceptawane")
BusinessTripStatus.find_or_create_by!(name: "Wniosek o zaliczkę")
BusinessTripStatus.find_or_create_by!(name: "Zatwierdzony wniosek o zaliczkę")
BusinessTripStatus.find_or_create_by!(name: "Uzupełniane")
BusinessTripStatus.find_or_create_by!(name: "Zweryfikowane")
BusinessTripStatus.find_or_create_by!(name: "Zakończone")

TransportType.find_or_create_by!(name: "PKP II kl.")
TransportType.find_or_create_by!(name: "Samochód służbowy")
TransportType.find_or_create_by!(name: "Samolot")


puts " "
puts "#####  END OF - business_trip_dict.rb  #####"
puts " "


