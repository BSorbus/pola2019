puts " "
puts "#####  RUN - update_enrollment.rb  #####"
puts " "

Project.all.each do |project|
  project.update_columns( enrollment_id: 2 )
end 


puts " "
puts "#####  END OF - update_enrollment.rb  #####"
puts " "
