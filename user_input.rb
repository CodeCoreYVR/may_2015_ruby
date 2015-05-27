load "user.rb"

print "give me your first name: "

first_name = gets.chomp

print "give me your last name: "

last_name = gets.chomp

user = User.new(first_name, last_name)

puts user.full_name
