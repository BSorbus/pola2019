puts " "
puts "#####  RUN - all.rb  #####"


# Attachment.all.each do |row| 
# #{|x|x.attached_file.recreate_versions!(:thumb)}
#   row.attached_file.cache_stored_file!
#   row.attached_file.recreate_versions!
#   row.save!
# end


instance = AbleUploader.new
instance.recreate_versions!(:thumb)


puts "#####  END OF - all.rb  #####"
puts " "

