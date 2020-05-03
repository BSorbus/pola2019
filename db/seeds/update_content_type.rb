puts " "
puts "#####  RUN - all.rb  #####"


# Attachment.all.each do |row| 
# #{|x|x.attached_file.recreate_versions!(:thumb)}
#   row.attached_file.cache_stored_file!
#   row.attached_file.recreate_versions!
#   row.save!
# end

  def override_content_type_and_save_info(at)
    case File.extname(at.attached_file.file.file).delete('.').downcase.to_sym
    when :xlsx
      content_type = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    when :docx
      content_type = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
    when :pptx
      content_type = 'application/vnd.openxmlformats-officedocument.presentationml.presentation'
    when :rar
      content_type = 'application/vnd.rar'
    when :zip
      content_type = 'application/zip'
    when :bat
      content_type = 'application/x-msdos-program'
    when :cmd
      content_type = 'application/cmd'
    when :php
      content_type = 'application/x-php'
    when :py
      content_type = 'application/x-python'
    when :vbs
      content_type = 'application/x-vbs'
    else
      content_type = at.attached_file.file.content_type
    end

    if at.file_content_type != content_type || at.attached_file.file.content_type != content_type || at.file_content_type != at.attached_file.file.content_type
      puts at.attached_file.file.filename
      puts "at.attached_file.file.content_type: "
      puts at.attached_file.file.content_type
      puts "at.file_content_type: "
      puts at.file_content_type
      puts "content_type: "
      puts content_type
    end 

    #at.update_columns(file_content_type: "#{content_type}")
  end

Attachment.where.not(attached_file: nil).order(:id).each do |attachment|
  puts '------------------------------------------------------'
  puts 'attachment.id:' 
  puts "  #{attachment.id}"
  puts "attachment.attached_file.file:"
  puts "  #{attachment.attached_file.file}"
  puts ''
#  if (attachment.attached_file.file.content_type == "application/vnd.rar") || (attachment.attached_file.file.content_type == "application/zip") 
#   attachment.attached_file.recreate_versions!(:thumb)
#  end
  override_content_type_and_save_info(attachment)
  puts "@licznik: #{@licznik}"
  puts '------------------------------------------------------'
end


CarrierWave.clean_cached_files!

puts "#####  END OF - all.rb  #####"
puts " "

