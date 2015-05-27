# Ask the user for personal information: first name, last name, city of birth and age.
# Then store that information in a hash. After that loop through the hash and
# display the results, for example:
#
# Your first name is Tam.
#
# Capitalize the inputs from the user if they are capitalizable

# Solution 1
# users = []
#
# personal_info = {} # You can also use Hash.new
#
# print "What is your first name: "
# first_name = gets.chomp
# personal_info["first name"] = first_name
#
# print "What is your last name: "
# last_name = gets.chomp
#
# print "What is your city: "
# city = gets.chomp
#
# print "What is your age: "
# age = gets.chomp
#
# personal_info = {"first name" => first_name, "last name" => last_name,
#                  "age"        => age,        "city"      => city }
#
# users << personal_info
#
# personal_info.each do |key, value|
#   puts "Your #{key} is #{value.capitalize}"
# end

# Solution 2

attributes = ["first name", "last name", "city", "age"]

names = {}

attributes.each do |i|
  print "What's your #{i}? "
  names[i] = gets.chomp.capitalize
end

names.each do |k, v|
  puts "Your #{k} is #{v}"
end
