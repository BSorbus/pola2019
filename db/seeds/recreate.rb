puts " "
puts "#####  RUN - all.rb  #####"


# Attachment.all.each do |row| 
# #{|x|x.attached_file.recreate_versions!(:thumb)}
#   row.attached_file.cache_stored_file!
#   row.attached_file.recreate_versions!
#   row.save!
# end


Attachment.all.each do |attachment|
  puts '------------------------------------------------------'
  puts 'attachment.id:' 
  puts "  #{attachment.id}"
  puts "attachment.attached_file.file:"
  puts "  #{attachment.attached_file.file}"
  puts ''
  attachment.attached_file.recreate_versions!(:thumb)
  puts '------------------------------------------------------'
end


CarrierWave.clean_cached_files!

puts "#####  END OF - all.rb  #####"
puts " "
