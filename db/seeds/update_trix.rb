puts " "
puts "#####  RUN - update_trix.rb  #####"
puts " "


puts 'Update Errand...'
Errand.order(:id).all.each do |row|
	if row.try(:note).length > 0
		unless row.note[0..4] == '<div>'
	 		note_after = row.note.gsub("\r\n","<br>")
	 		note_after = note_after.gsub("•\\'","<br>•")
			note_after = '<div>' + note_after + '</div>'

			# puts '----------------------------------------------------------------'
			# puts row.id
			# puts row.note
			# puts note_after
			# sleep 2
			# puts '----------------------------------------------------------------'

			puts row.id
	  	row.update_columns( note: note_after )
	  end
	end
end 

puts 'Update Enrollment...'
Enrollment.order(:id).all.each do |row|
	if row.try(:note).length > 0
		unless row.note[0..4] == '<div>'
	 		note_after = row.note.gsub("\r\n","<br>")
	 		note_after = note_after.gsub("•\\'","<br>•")
			note_after = '<div>' + note_after + '</div>'

			puts row.id
	  	row.update_columns( note: note_after )
	  end
	end
end 

puts 'Update Event...'
Event.order(:id).all.each do |row|
	if row.try(:note).length > 0
		unless row.note[0..4] == '<div>'
	 		note_after = row.note.gsub("\r\n","<br>")
	 		note_after = note_after.gsub("•\\'","<br>•")
			note_after = '<div>' + note_after + '</div>'

			puts row.id
	  	row.update_columns( note: note_after )
	  end
	end
end 

puts 'Update Project...'
Project.order(:id).all.each do |row|
	if row.try(:note).length > 0
		unless row.note[0..4] == '<div>'
	 		note_after = row.note.gsub("\r\n","<br>")
	 		note_after = note_after.gsub("•\\'","<br>•")
			note_after = '<div>' + note_after + '</div>'

			puts row.id
	  	row.update_columns( note: note_after )
	  end
	end
end 

puts 'Update Customer...'
Customer.order(:id).all.each do |row|
	if row.try(:note).length > 0
		unless row.note[0..4] == '<div>'
	 		note_after = row.note.gsub("\r\n","<br>")
	 		note_after = note_after.gsub("•\\'","<br>•")
			note_after = '<div>' + note_after + '</div>'

			puts row.id
	  	row.update_columns( note: note_after )
	  end
	end
end 

puts 'Update User...'
User.order(:id).all.each do |row|
	if row.try(:note).length > 0
		unless row.note[0..4] == '<div>'
	 		note_after = row.note.gsub("\r\n","<br>")
	 		note_after = note_after.gsub("•\\'","<br>•")
			note_after = '<div>' + note_after + '</div>'

			puts row.id
	  	row.update_columns( note: note_after )
	  end
	end
end 


puts 'Update Role...'
Role.order(:id).all.each do |row|
	if row.try(:note).length > 0
		unless row.note[0..4] == '<div>'
	 		note_after = row.note.gsub("\r\n","<br>")
	 		note_after = note_after.gsub("•\\'","<br>•")
			note_after = '<div>' + note_after + '</div>'

			puts row.id
	  	row.update_columns( note: note_after )
	  end
	end
end 



puts " "
puts "#####  END OF - update_trix.rb  #####"
puts " "
