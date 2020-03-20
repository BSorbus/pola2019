puts " "
puts "#####  RUN - zip.rb  #####"
puts " "

require 'fileutils'
require 'zip'
require 'zip_file_generator'

include ActionView::Helpers::TextHelper

#   directory_to_zip = "/tmp/input"
#   output_file = "/tmp/out.zip"
#   zf = ZipFileGenerator.new(directory_to_zip, output_file)
#   zf.write()

# dir_to_zip = Rails.root.join('tmp', 'test', 'controllers').to_s
# out_file = Rails.root.join('tmp', 'test/out.zip').to_s
# zf = ZipFileGenerator.new(dir_to_zip, out_file)
# zf.write()

attachmenable_name = "POPC_1234"
#attachmenable_name = truncate(Attachment.find(62875).attachmenable.title, lenght: 30)
timestamp = Time.now.strftime("%Y%m%d%H%M%6N")
root_dir_to_zip = Rails.root.join('tmp', 'zipownia', "#{attachmenable_name}_#{timestamp}").to_s
out_file = root_dir_to_zip + "/file#{timestamp}.zip"  


attachments_ids = []
# W katalogu Korespondencja
attachments_ids << 76668 << 76664 << 76663  << 76669

# w katalogu głównym
#attachments_ids << 62869 << 76640 << 76638  << 76660

# def copy_attachments_to_tmp(attachments_list, root_dir)

#   attachments_list.each do |attachment_id|
#     attachment = Attachment.find(attachment_id)
#     attachment_ancestors_names = attachment.ancestors.map(&:name)
#     dest_path = attachment_ancestors_names.blank? ? "#{root_dir}" : "#{root_dir}/#{attachment_ancestors_names.reverse.join('/')}"
#     if attachment.is_file?
#       puts "copy file for attachment_id: #{attachment.id}"
#       source_file_name_with_path = attachment.attached_file.file.file   
#       dest_file_name_with_path = "#{dest_path}/#{attachment.name}"
#       #puts "#{attachment.name}"
#       puts "source file: #{source_file_name_with_path}"
#       puts "destination file: #{dest_file_name_with_path}"
#       FileUtils.cp(source_file_name_with_path, dest_file_name_with_path)  unless File.exists?(dest_file_name_with_path)
#     else
#       puts "create directory for attachment_id: #{attachment.id}"
#       dest_directory_name_with_path = "#{dest_path}/#{attachment.name}"
#       puts dest_directory_name_with_path
#       FileUtils.mkdir_p dest_directory_name_with_path unless File.exists?(dest_directory_name_with_path)
#       copy_attachments_to_tmp(attachment.child_ids, root_dir)
#     end
#   end
  
# end

#copy_attachments_to_tmp(attachments_ids, root_dir_to_zip)

aaa = PreparationForZipFileGenerator.new('POPC', attachments_ids)
aaa.copy_attachments_to_tmp

puts aaa.root_dir_to_zip
puts aaa.out_zip_file

zf = ZipFileGenerator.new(aaa.root_dir_to_zip, aaa.out_zip_file)
zf.write()

puts " "
puts "#####  END OF - zip.rb  #####"
puts " "


