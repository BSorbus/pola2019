


# doc = Nokogiri::XML(File.open("db/seeds/wniosek.xml")) do |config|
#   config.strict.nonet
# end

# # puts '------------------------------------------'
#   doc.remove_namespaces! # Remove namespaces from xml to make it clean
#   print doc
# # puts '------------------------------------------'


#doc = Nokogiri::XML(xml_doc)
#puts '------------------------------------------'

my_json = {"id":1,"address":"460 Jane St.","rooms":2,"bathrooms":2,"price":900.0,"price_per_room":450.0,"user":{"id":1,"name":"A. Serna","email":"email1@sample.com"}}

puts JSON.pretty_generate(my_json).html_safe


j = Work.last.parameters
jp = JSON.parse(j)
puts JSON.pretty_generate(jp)