puts " "
puts "#####  RUN - test0.rb  #####"
puts " "


def method_name1
  puts 'fired method_name1'
  false
end

def method_name2
  puts 'fired method_name2'
  true
end

def method_name3
  puts 'fired method_name3'
  true
end


def method_test
  if method_name1 || method_name2 || method_name3
    puts 'fired test'
    puts 'return true'
  else
    puts 'fired test'
    puts 'return false'
  end
end


method_test


puts " "
puts "#####  END OF - test0.rb  #####"
puts " "


