puts " "
puts "#####  RUN - test.rb  #####"
puts " "



  attachment = Attachment.last
  # puts attachment.attached_file.file.filename
  # puts attachment.attached_file.url
  # puts attachment.attached_file.path

  file = attachment.attached_file.path

  # #system("exiftool #{file}")

  # photo = MiniExiftool.new "#{file}"
  # puts ''
  # puts photo.gpsmapdatum
  # puts photo.gpslatitude
  # puts photo.gpslatitude.split[0]
  # puts photo.gpslatitude.split[2]
  # puts photo.gpslatitude.split[3]
  # puts photo.gpslatitude.split[4]



  # puts photo.gpslongitude
  # puts photo.gpslongitude.split


  # require 'open3'
  # Open3.popen3("ls") do |stdout, stderr, status, thread|
  #   puts stdout.read
  # end



 out_doc = %x{
      exiftool "#{file}"
    }

    #doc = Nokogiri::XML(xml_doc)
    print out_doc





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


