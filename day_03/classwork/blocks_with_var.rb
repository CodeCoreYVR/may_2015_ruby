def my_method
  x = rand(100)
  yield(x) if block_given?
end

my_method do |x|
  puts "the random number is #{x}"
end
# as if the method becomes
# def my_method
#   x = rand(100)
#   puts "the random number is #{x}"
# end

my_method do |num|
  if num > 50
    puts "You Won"
  else
    puts "You Lost"
  end
end
# as if the method becomes
# def my_method
#   x = rand(100)
#   if x > 50
#     puts "You Won"
#   else
#     puts "You Lost"
#   end
# end
