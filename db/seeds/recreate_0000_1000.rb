puts " "
puts "#####  RUN - all.rb  #####"


# Attachment.all.each do |row| 
# #{|x|x.attached_file.recreate_versions!(:thumb)}
#   row.attached_file.cache_stored_file!
#   row.attached_file.recreate_versions!
#   row.save!
# end

CarrierWave.clean_cached_files!


Attachment.where.not(attached_file: nil).where('id > 0 AND id <= 1000').order(:id).each do |attachment|
  puts '------------------------------------------------------'
  puts 'attachment.id:' 
  puts "  #{attachment.id}"
  puts "attachment.attached_file.file:"
  puts "  #{attachment.attached_file.file}"
  puts ''
  if (attachment.file_content_type == 'application/vnd.rar' ) ||
     (attachment.file_content_type == 'application/zip' )
  	attachment.attached_file.recreate_versions!(:thumb)
  end
  puts '------------------------------------------------------'
end


CarrierWave.clean_cached_files!

puts "#####  END OF - all.rb  #####"
puts " "

