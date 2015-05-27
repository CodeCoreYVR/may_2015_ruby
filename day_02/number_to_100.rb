print "Give me a number: "

n = gets.chomp.to_i

if n <= 100
  for input in n..100
    puts input
  end
  # while n <= 100
  #   puts n
  #   n += 1
  # end
else
  puts "You number is greater than a 100"
end
