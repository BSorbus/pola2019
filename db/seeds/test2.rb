puts " "
puts "#####  RUN - test.rb  #####"
puts " "


# 49 deg 46' 7.90\" N
# 22 deg 42' 57.42\" E

def dms_to_float(lat_or_long)
  lat_or_long.gsub!(/deg/,'').gsub!(/\"/,'').gsub!("'","")

  value = lat_or_long.split[0].to_f + lat_or_long.split[1].to_f/60 + lat_or_long.split[2].to_f/3600

  value = -1 * value if lat_or_long.split[3] == 'S'

  return value
end


  attachment = Attachment.last
  puts attachment.attached_file.file.filename
  puts attachment.attached_file.url
  puts attachment.attached_file.path
 
  file = attachment.attached_file.path

  #system("exiftool #{file}")

  photo = MiniExiftool.new "#{file}"
  puts ''
#  puts photo.gpsmapdatum
  puts '--------------------------------------------------'
  puts photo.gpslatitude
  puts dms_to_float(photo.gpslatitude)
  puts '--------------------------------------------------'
  puts photo.gpslongitude
  puts dms_to_float(photo.gpslongitude)
  puts '--------------------------------------------------'


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


