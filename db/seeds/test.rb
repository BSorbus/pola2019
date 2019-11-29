puts " "
puts "#####  RUN - test.rb  #####"
puts " "




  attachment = Attachment.last
  puts attachment.attached_file.file.filename
  puts attachment.attached_file.url
  puts attachment.attached_file.path

  photo = attachment.attached_file.path

  system("exiftool #{photo}")

# File.open("db/seeds/wniosek.xml")

#       correspondence.attached_file = File.new(File.join(Rails.root, '/public' + only_file_path(self.attached_file.url) + self.attached_file.file.filename))



# File.open(File.join("db/seeds/files/log", 'swiadectwo_gd.log'), 'a+') do |f|
#   f.puts "#####  203_certificates_gd.rb  #####"
#   f.puts "Certificates all: #{Certificate.all.size}"
#   f.puts "... load from db/seeds/files/swiadectwo_gd.csv... start..."
# end 


#   exiftool FOTO1.JPG


puts " "
puts "#####  END OF - test.rb  #####"
puts " "


