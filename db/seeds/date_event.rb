puts " "
puts "#####  RUN - seed_all.rb  #####"
puts " "

Event.all.each do |event|
  event.update_columns( created_at: event.errand.order_date )
end 


puts " "
puts "#####  END OF - seed_all.rb  #####"
puts " "
