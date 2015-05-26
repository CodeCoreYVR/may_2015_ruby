puts "When was your car made?"

year = gets.chomp.to_i

if year > 2015
  puts "Future"
elsif year > 2014
  puts "New"
elsif year > 2010
  puts "relatively new"
elsif year > 2000
  puts "Old"
else
  puts "very old"
end



# if year < 1990
#   puts "Your car is very old"
# elsif year < 2000
#   puts "Your car is old"
# elsif year >= 2000 && year <= 2015
#   puts "Your car is new"
# else
#   puts "Your car is in the future"
# end

# current_year = 2015
#
# if current_year - year < 0
#   puts "Future"
# elsif current_year - year >= 0 && current_year - year < 3
#   puts "New"
# elsif current_year - year > 3 && current_year - year <= 8
#   puts "Old"
# else
#   puts "Very Old"
# end
