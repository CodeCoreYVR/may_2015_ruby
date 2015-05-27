def greetings
  puts "Hello"
  yield if block_given?
  puts "Hi"
end

greetings do
  puts "hey"
end

greetings do
  puts "Hola"
end

greetings

# this is as if I altered the greetings method to become like
# def greetings
#   puts "Hello"
#   puts "hey"
#   puts "Hi"
# end
