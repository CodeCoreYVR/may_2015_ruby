def greeting(name)
  puts "Greetings #{name}!"
end

print "What is your name? "
user_name = gets.chomp
greeting(user_name)
